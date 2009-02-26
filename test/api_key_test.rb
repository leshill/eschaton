require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

GOOGLE_MAPS_API_KEY = "key_from_constant"

class ApiKeyTest < Test::Unit::TestCase

  def setup
    @config_file = "#{File.dirname(__FILE__)}/test_api_keys.yml"
  end

  def test_get
    
    
    assert_equal 'test_key', Google::ApiKey.get(:config_file => config_file)
    assert_equal 'key_for_localhost', Google::ApiKey.get(:config_file => config_file, :domain => 'localhost')
    assert_equal 'key_for_test_localhost', Google::ApiKey.get(:config_file => config_file, :domain => 'test.localhost') 

    assert_equal 'key_from_constant', Google::ApiKey.get(:config_file => "no_such_file")    

    # Now remove the API key constant and the config file doesn't exist
    Object.send :remove_const, :GOOGLE_MAPS_API_KEY
    assert_equal 'ABQIAAAActtI8WkgLZcM_n8uvnIYsBTJQa0g3IQ9GZqIMmInSLzwtGDKaBT9A95dZjICm7SeC_GoxpzGlyCdQA', 
                 Google::ApiKey.get(:config_file => "no_such_file")
  end
  
  def test_key_cached
    
    
   p Google::ApiKey.get(:config_file => @config_file)
   p Google::ApiKey.get(:config_file => @config_file, :domain => 'localhost')  
   p Google::ApiKey.get(:config_file => @config_file, :domain => 'test.localhost')      
    
  end
  

end