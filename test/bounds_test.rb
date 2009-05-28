require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class BoundsTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|      
      assert_output_fixture "bounds = new GLatLngBounds(new GLatLng(-34.947, 19.462), new GLatLng(-35.947, 20.462));",
                            script.record_for_test {
                              Google::Bounds.new(:south_west_point => [-34.947, 19.462], :north_east_point => [-35.947, 20.462])
                            }
        
      assert_output_fixture "bounds = new GLatLngBounds();",
                            script.record_for_test {
                              Google::Bounds.new
                            }        
        
    end
  end

  def test_extend
    with_eschaton do |script|
      bounds = Google::Bounds.new

      assert_output_fixture "bounds.extend(marker.getLatLng());",
                            script.record_for_test {
                              bounds.extend 'marker.getLatLng()'
                            }

      assert_output_fixture "bounds.extend(new GLatLng(-36.947, 21.462));",
                            script.record_for_test {
                              bounds.extend [-36.947, 21.462]
                            }    

      other_bounds = Google::Bounds.new(:south_west_point => [-34.947, 19.462], :north_east_point => [-35.947, 20.462])
                                      
      assert_output_fixture "bounds.extend(new GLatLng(-34.947, 19.462));
                             bounds.extend(new GLatLng(-35.947, 20.462));",
                            script.record_for_test {
                              bounds.extend other_bounds
                            }
                            
     assert_output_fixture "bounds.extend(marker.getLatLng());
                            bounds.extend(new GLatLng(-36.947, 21.462));
                            bounds.extend(new GLatLng(-34.947, 19.462));
                            bounds.extend(new GLatLng(-35.947, 20.462));",
                           script.record_for_test {
                             bounds.extend 'marker.getLatLng()', [-36.947, 21.462], other_bounds
                           }
    end
  end

end