require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class JavascriptVariableTest < Test::Unit::TestCase

  def test_new_variable
    Eschaton.with_global_script do |script|
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
    Eschaton.with_global_script do |script|
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
    Eschaton.with_global_script do |script|
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

end