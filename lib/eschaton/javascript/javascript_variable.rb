module Eschaton

  # Encapsulates a javascript variable in a Ruby variable. This can be used to work with a javascript variable within Ruby.
  #
  # ==== Examples
  #  # Create a new variable
  #  my_array = JavascriptVariable.new(:name => :my_array, :value => "new Array()")
  #  my_array.push("One")
  #  my_array.push(2)
  #  my_array.push("Three")
  #
  #  my_array.splice(1, 0, "A new item at position 1")
  #
  #  # Reference an existing variable
  #  my_existing_array = JavascriptVariable.existing(:var => :my_array)
  #  my_existing_array.push("Four")
  #  my_existing_array.push(5)
  class JavascriptVariable < JavascriptObject

    def initialize(options = {})
      options.default! :value => nil, :var => options[:name]

      super

      if self.create_var?
        self << "var #{self.var} = #{options[:value]};"
      end
    end
  end

end