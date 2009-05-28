class JavascriptGeneratorTranslator

  def initialize
    self.javascript_generator = ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(Eschaton.current_view){}
  end

  def added_to_eschaton_code_page(code_page)
    # Overwrite the generators lines
    self.javascript_generator.instance_eval do |instance|
      instance.instance_variable_set(:@lines, code_page.lines)
    end
  end

  def method_missing(method_id, *args, &block)
    self.javascript_generator.send(method_id, *args, &block)
  end

  protected
    attr_accessor :javascript_generator
end