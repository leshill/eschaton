module Google

  # Represents a overlay that can be added to a Map using Map#add_ground_overlay. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GGroundOverlay] docs for details. 
  # See MapObject#listen_to on how to use # events not listed on this object.
  class GroundOverlay < MapObject
    attr_reader :bounds, :image

    # ==== Options:
    # * +image+ - Required. The image url that should be used as the overlay.
    # * +bounds+ - Optional. The bounds that represent the rectangle of the overlay. Can be a Bounds or whatever 
    #   Bounds#new supports. If you don't use this option +south_west_point+ and +north_east_point+ can be used explicitly.
    # * +south_west_point+ - Optional. The south west point of the rectangle. 
    # * +north_east_point+ - Optional. The north east point of the rectangle.
    def initialize(options = {})
      options.default! :var => :ground_overlay, :image => ''

      super

      if create_var?
        self.bounds = if options.has_option?(:bounds)
                        Google::OptionsHelper.to_bounds(options[:bounds])
                      else
                        Google::Bounds.new(:south_west_point => options.extract(:south_west_point), 
                                           :north_east_point => options.extract(:north_east_point))
                      end

        self.image = options.extract(:image)

        self << "#{self.var} = new GGroundOverlay('#{self.image}', #{self.bounds});"
      end
    end

    protected
      attr_writer :bounds, :image
  end
end
