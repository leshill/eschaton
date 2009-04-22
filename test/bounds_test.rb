require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class BoundsTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|

      bounds = Google::Bounds.new(:south_west_point => [-34.947, 19.462], :north_east_point => [-35.947, 20.462])
      bounds_output = "new GLatLngBounds(new GLatLng(-34.947, 19.462), new GLatLng(-35.947, 20.462))"
      
      assert_equal bounds_output, bounds.to_s
      assert_equal bounds_output, bounds.to_js
      assert_equal bounds_output, bounds.to_json      
    end
  end

end