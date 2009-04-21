module Google

  # Represents a overlay that can be added to a Map using Map#add_ground_overlay. 
  class GroundOverlay < MapObject
    attr_reader :vertices
    def initialize(options = {})
      options.default! :var => 'ground_overlay',
                       :vertices => [],
                       :sw => [],
                       :ne => [],
                       :image_url => ''

      super
      if create_var?                                                           
        sw = options.extract(:sw)
        ne = options.extract(:ne)
        image_url = options.extract(:image_url)
        self.vertices = options.extract(:vertices)
        remaining_options = options

        self.vertices << Google::OptionsHelper.to_location(sw)
        self.vertices << Google::OptionsHelper.to_location(ne)


        self << "#{self.var} = new GGroundOverlay('#{image_url}', new GLatLngBounds(new GLatLng(#{sw.join(',')}), new GLatLng(#{ne.join(',')})));"
      end
    end
    protected
      attr_writer :vertices
  end
end
