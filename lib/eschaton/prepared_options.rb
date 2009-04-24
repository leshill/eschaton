module Eschaton
  
  # Helps with writing methods that take a +options+ hash.
  class PreparedOptions

    def initialize(options = {})
      self.options = options.clone
      self.options.symbolize_keys!
    end

    def [](*options)
      if options.size == 1
        self.options[options.first]
      else
        hash = {}

        options.each do |option|
          hash[option] = self[option]
        end

        hash.symbolize_keys
      end
    end

    def []=(option, value)
      self.options[option] = value
    end
    
    # Returns a value indicating if the +option+ is present.
    def has_option?(option)
      self.options.has_key?(option)
    end

    # Returns a value indicating if the +option+ has a value.
    def has_value?(option)
      self[option].not_nil?
    end    

    # Defaults options if they are not present of have a nil value.
    #
    #   prepared_options.default! :always_sync => true, :sync_interval => 10.seconds
    def default!(defaults)
      defaults.each do |option, default_value|
        self[option] = default_value unless self.has_value?(option)
      end
    end

    # Validates that the given +options+ are present and do not have blank values
    #
    #  prepared_options.validate_presence_of :name, :project
    def validate_presence_of(*options)
      missing_options = options.select do |required_option|
                          self[required_option].blank?
                        end

      if missing_options.not_empty?
        raise ArgumentError, "The following options require values: #{missing_options.join(', ')}"
      end
    end

    # Yields the value for the given +option+ and updates the option to whatver the block returns.
    #
    #  # Instead of doing this
    #  prepared_options[:date] = Date.parse(prepared_options[:date])
    #
    #  # You can do this
    #  prepared_options.update(:date) do |date|
    #    Date.parse(date)
    #  end
    def update(option)
      self[option] = yield(self[option])
    end

    def inspect
      output = "#{self.options.size} Options:\n"

      self.options.each do |option, value|
        output << "  #{option} => #{value.inspect}\n"
      end

      output
    end
    
    protected
      attr_accessor :options
  end  

end