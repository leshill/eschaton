module Google

  # Represents a rectangle in geographical coordinates, including one that crosses the 180 degrees meridian.
  # See googles online[http://code.google.com/apis/maps/documentation/reference.html#GLatLngBounds] docs for details.
  class Bounds < MapObject
    attr_reader :south_west_point, :north_east_point 
    
    # ==== Options:
    # * +south_west_point+ - Optional. The south west point of the rectangle.
    # * +north_east_point+ - Optional. The north east point of the rectangle.
    def initialize(options = {})
      options.default! :var => :bounds

      super

      self.south_west_point = Google::OptionsHelper.to_location(options[:south_west_point])
      self.north_east_point = Google::OptionsHelper.to_location(options[:north_east_point])

      if create_var?
        points = [self.south_west_point, self.north_east_point].compact
        self << "#{self.var} = new GLatLngBounds(#{points.join(', ')});"
      end
    end
    
    # Extends the bounds with the given +locations+. Which can be Location or Bounds.
    def extend(*locations)
      locations.arify.each do |location|
        if location.is_a?(Google::Bounds)
          self << "#{self}.extend(#{location.south_west_point});"
          self << "#{self}.extend(#{location.north_east_point});"
        else
          location = Google::OptionsHelper.to_location(location)
          self << "#{self}.extend(#{location});"
        end
      end
    end

    def center
      "#{self}.getCenter()"
    end

    protected
      attr_writer :south_west_point, :north_east_point
  end
end
