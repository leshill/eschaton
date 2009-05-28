module Eschaton
  
  class CodePage
    attr_reader :lines

    def initialize(options = {})
      self.original_options = options
      
      options.default! :translators => []
      
      self.lines = []

      setup_translators options[:translators]    
    end

    def self.capture(options = {})
      code_page = Eschaton::CodePage.new(options)
      
      Eschaton::CodePage.as_current(code_page) do    
        yield code_page
      end
      
      code_page
    end

    def self.current=(code_page)
      Thread.current[:eschaton_current_code_page] = code_page
    end

    def self.current
      current_code_page = Thread.current[:eschaton_current_code_page]

      yield current_code_page if block_given?

      current_code_page
    end

    def <<(item)
      self.lines << item

      item
    end
    
    def self.<<(value)
      Eschaton::CodePage.current << value
    end
    
    def inject(options = {})
      code_page = CodePage.new(self.original_options.merge(options))
      self << code_page

      Eschaton::CodePage.as_current(code_page) do
        yield code_page if block_given?
      end

      code_page
    end

    def to_s
      self.lines.flatten.collect {|item|
        if item.respond_to?(:for_eschaton_code_page)
          item.for_eschaton_code_page
        else
          item.to_s
        end
      }.join("\n")
    end
  
    def method_missing(method_id, *args, &block)
      self.translators.each do |translator|
        begin
          return translator.send(method_id, *args, &block)
        rescue NoMethodError
        end
      end

      super
    end

    protected
      attr_writer :lines    
      attr_accessor :original_options, :translators
      
      def self.as_current(code_page)
        previous_current_code_page = Eschaton::CodePage.current

        Eschaton::CodePage.current = code_page

        yield code_page

        Eschaton::CodePage.current = previous_current_code_page
      end

      def setup_translators(translators)
        self.translators = []

        translators.arify.each do |translator|
          translator = module_to_translator(translator) if translator.class == Module
          
          translator.send(:attr_accessor, :code_page)

          translator_instance = translator.new
          translator_instance.code_page = self

          self.translators << translator_instance
          translator_instance.added_to_eschaton_code_page(self) if translator_instance.respond_to?(:added_to_eschaton_code_page)
        end      
      end
      
      def module_to_translator(translation_module)
        wrapper_class = Class.new
        wrapper_class.send(:include, translation_module)
        wrapper_class        
      end 

  end

end