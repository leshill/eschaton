module Eschaton

  class JavascriptReturner
    extend Eschaton::ReadableAttributes

    attributes :var => Eschaton::ReadableAttributes.public_reader_protected_writer,
               :return_value => Eschaton::ReadableAttributes.public_reader_protected_writer

    def initialize(options = {})
      self.var = options[:var]
      self.return_value = nil
    end

    # Converts the given +method+ and +args+ to a javascript method call with arguments.  
    def method_to_js(method, *args)
      self.return_value = "#{self.var}.#{method.to_js_method}(#{args.to_js_arguments})"
    end

    alias method_missing method_to_js
    alias to_s return_value    
  end
    
end