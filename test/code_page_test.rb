require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

module SimpleTranslation

  def simple_hello
    self.code_page << "Simple Hello!"
  end

  def simple_goodbye
    self.code_page << "Simple Goobye!"    
  end
  
end
    
class CodePageTest < Test::Unit::TestCase
    
  def test_simple_write
    code_page = Eschaton::CodePage.capture do |code_page|
                  code_page << "Line 1"
                  code_page << "Line 2"
                  code_page << "Line 3"
                end

    assert_eschaton_output 'Line 1
                            Line 2
                            Line 3', code_page.to_s
  end
  
  def test_simple_write_on_current
    code_page = Eschaton::CodePage.capture do |code_page|
                  Eschaton::CodePage << "Line 1"
                  Eschaton::CodePage << "Line 2"
                  Eschaton::CodePage << "Line 3"
                end

    assert_eschaton_output 'Line 1
                            Line 2
                            Line 3', code_page.to_s    
  end
  
  def test_inject
    code_page = Eschaton::CodePage.capture do |code_page|
                  code_page << "First Level"
                  
                  code_page << "Before Second Level"
                  code_page.inject do |second_level|
                    assert second_level != code_page
                    second_level << "Second Level"
                    
                    code_page << "Before Third Level"
                    code_page.inject do |third_level|
                      assert third_level != code_page
                      third_level << "Third Level"
                    end  
                    code_page << "After Third Level"                    
                  end
                  code_page << "After Second Level"
                end

    assert_eschaton_output 'First Level
                            Before Second Level
                            Second Level
                            Before Third Level
                            Third Level
                            After Third Level
                            After Second Level', code_page.to_s              
  end
  
  def test_current
    assert_nil Eschaton::CodePage.current

    code_page = Eschaton::CodePage.capture do |code_page|
                  assert_equal Eschaton::CodePage.current, code_page
                  code_page << "First Level"
                  Eschaton::CodePage << "First level writing to current"

                  code_page.inject do |second_level|
                    assert_equal Eschaton::CodePage.current, second_level
                    second_level << "Second Level"
                    Eschaton::CodePage << "Second level writing to current"
                  end
                  
                  assert_equal Eschaton::CodePage.current, code_page
                end

   assert_nil Eschaton::CodePage.current
 
   assert_eschaton_output 'First Level
                           First level writing to current
                           Second Level
                           Second level writing to current', code_page.to_s
  end

  def test_translators_with_classes
    code_page = Eschaton::CodePage.capture(:translators => JavascriptGeneratorTranslator) do |code_page|
                  code_page << "Normal Write!"
                  code_page.alert("Hello")
                  code_page[:meeting_name].focus
                  code_page[:meeting_list].replace_html :partial => 'meeting_list'
                  code_page.event.call("Hello")
                end

    assert_eschaton_output 'Normal Write!
                            alert("Hello");
                            $("meeting_name").focus();
                            $("meeting_list").update("test output for render");
                            Event.call("Hello");', code_page.to_s
  end
  
  def test_translators_with_modules
    code_page = Eschaton::CodePage.capture(:translators => SimpleTranslation) do |code_page|
                  code_page << "Start Normal Write!"

                  code_page.simple_hello
                  code_page.simple_goodbye
                  
                  code_page << "End Normal Write!"
                end

    assert_eschaton_output 'Start Normal Write!
                            Simple Hello!
                            Simple Goobye!
                            End Normal Write!', code_page.to_s    
    
  end
  
  def test_translators_with_module_and_class
    code_page = Eschaton::CodePage.capture(:translators => [SimpleTranslation,
                                                            JavascriptGeneratorTranslator]) do |code_page|
                
                  code_page << "Start Normal Write!"

                  code_page.simple_hello
                  code_page.simple_goodbye
                  
                  code_page.alert("Hello")
                  code_page[:meeting_name].focus
                  code_page[:meeting_list].replace_html :partial => 'meeting_list'
                  code_page.event.call("Hello")

                  code_page << "End Normal Write!"
                end
       
    assert_eschaton_output 'Start Normal Write!
                            Simple Hello!
                            Simple Goobye!
                            alert("Hello");
                            $("meeting_name").focus();
                            $("meeting_list").update("test output for render");
                            Event.call("Hello");
                            End Normal Write!', code_page.to_s       
                
  end
  
  
  def test_new_translator_created_with_every_code_page
    code_page = Eschaton::CodePage.capture(:translators => JavascriptGeneratorTranslator) do |code_page|
                  code_page.alert("First Level")

                  code_page.alert("Before Second Level")

                  # Assert that the correct translator and codepage are being used
                  assert_equal code_page, code_page.send(:translators).first.code_page

                  code_page.inject do |second_level|
                    # Assert that a new instance of JavascriptGeneratorTranslator 
                    assert_not_equal code_page.send(:translators).first, second_level.send(:translators).first
                    
                   # Assert that the correct translator and codepage are being used within an inject
                    assert_equal second_level, second_level.send(:translators).first.code_page
                    
                    second_level.alert("Second level")
                  end

                  # Assert that the correct translator and code page are intact after inject
                  assert_equal code_page, code_page.send(:translators).first.code_page
                  
                  code_page.alert("After Second Level")
                end

    assert_eschaton_output 'alert("First Level");
                            alert("Before Second Level");
                            alert("Second level");
                            alert("After Second Level");',
                           code_page.to_s
  end


end
