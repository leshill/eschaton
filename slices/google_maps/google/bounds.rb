module Google

  # Represents a rectangle in geographical coordinates, including one that crosses the 180 degrees meridian.
  # See googles online[http://code.google.com/apis/maps/documentation/reference.html#GLatLngBounds] docs for details.
  class Bounds < MapObject
    attr_reader :south_west_point, :north_east_point 
    
    # ==== Options:
    # * +south_west_point+ - Optional. The south west point of the rectangle.
    # * +north_east_point+ - Optional. The north east point of the rectangle.
    def initialize(options = {})
      options.default!

      super

      self.south_west_point = Google::OptionsHelper.to_location(options[:south_west_point])
      self.north_east_point = Google::OptionsHelper.to_location(options[:north_east_point])
    end

    def to_s
      "new GLatLngBounds(#{self.south_west_point.to_js}, #{self.north_east_point.to_js})"
    end

    alias to_js to_s
    def to_json(options = nil)
      to_js
    end

    protected
      attr_writer :south_west_point, :north_east_point
  end
end
