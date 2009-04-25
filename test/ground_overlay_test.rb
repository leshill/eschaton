require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class GroundOverlayTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|
      output = "bounds = new GLatLngBounds(new GLatLng(-33.947, 18.462), new GLatLng(-34.947, 19.462));
                ground_overlay = new GGroundOverlay('http://battlestar/images/cylon_base_star.png', bounds);"
      
      # Using explicit points for Bounds
      assert_output_fixture output,
                            script.record_for_test {
                              Google::GroundOverlay.new :image => "http://battlestar/images/cylon_base_star.png",
                                                        :south_west_point => [-33.947, 18.462],
                                                        :north_east_point => [-34.947, 19.462]
                             }

      # Using a bounds object
      assert_output_fixture output,
                            script.record_for_test {
                              Google::GroundOverlay.new :image => "http://battlestar/images/cylon_base_star.png",
                                                        :bounds => Google::Bounds.new(:south_west_point => [-33.947, 18.462], 
                                                                                      :north_east_point => [-34.947, 19.462])
                            }

      # using Bounds in array form
      assert_output_fixture output,
                            script.record_for_test {
                              Google::GroundOverlay.new :image => "http://battlestar/images/cylon_base_star.png",
                                                        :bounds => [[-33.947, 18.462], [-34.947, 19.462]]
                            }
    end
  end

end