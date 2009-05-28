require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class GravatarIconTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|
      assert_eschaton_output :gravatar do
                               Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com'
                            end

      assert_eschaton_output :gravatar_with_size do
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :size => 50
                            end

      assert_eschaton_output :gravatar_with_default_icon do
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png'
                            end

      assert_eschaton_output :gravatar_with_size_and_default_icon do
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png',
                                                       :size => 50
                            end
    end
  end

end
