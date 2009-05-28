require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class JavascriptVariableTest < Test::Unit::TestCase

  def test_new_variable
    with_eschaton do |script|
      assert_output_fixture 'var points = new Array();
                             points.push("One");
                             points.push("Two");',
                            script.record_for_test {
                              points = Eschaton::JavascriptVariable.new(:name => :points, :value => "new Array()")
                              points.push("One")
                              points.push("Two")                              
                            }      
    end
  end

  def test_existing_variable
    with_eschaton do |script|
      assert_output_fixture 'points.push("One");
                             points.push("Two");',
                            script.record_for_test {
                              points = Eschaton::JavascriptVariable.existing(:name => :points)
                              points.push("One")
                              points.push("Two")                              
                            }      
    end
  end

  def test_method_translation
    with_eschaton do |script|
      assert_output_fixture 'var points = new Array();
                             points.push("One");
                             points.push("Two");
                             points.translateToCamelCase();
                             points.withTwoArguments("One", 2);',
                            script.record_for_test {
                              points = Eschaton::JavascriptVariable.new(:name => :points, :value => "new Array()")

                              points.push("One")
                              points.push("Two")
                              points.translate_to_camel_case!
                              points.with_two_arguments("One", 2)
                            }
    end
  end
  
  def test_array_accessor
    with_eschaton do |script|
      points = Eschaton::JavascriptVariable.new(:name => :points, :value => "new Array()")

      assert_returned_javascript 'points[1]', points[1]
      assert_returned_javascript 'points["Hello"]', points["Hello"]
      assert_returned_javascript 'points[a_marker]', points[:a_marker]

      assert_output_fixture 'points[1] = 1;', 
                            script.record_for_test {
                              points[1] = 1
                            }

      assert_output_fixture 'points[1] = "Hello";', 
                            script.record_for_test {
                              points[1] = "Hello"
                            }

      assert_output_fixture 'points[1] = a_marker;', 
                            script.record_for_test {
                              points[1] = :a_marker
                            }
    end    
  end

end