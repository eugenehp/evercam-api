require_relative '../errors'

class Camera < Sequel::Model

  include GeoRuby::SimpleFeatures

  many_to_one :firmware
  one_to_many :endpoints, class: 'CameraEndpoint'
  many_to_one :owner, class: 'User'

  # Finds the camera with a matching external id
  # (exid) string or nil if none exists
  def self.by_exid(exid)
    first(exid: exid)
  end

  # Like by_exid but will raise an Evercam::NotFoundError
  # if the camera does not exist
  def self.by_exid!(exid)
    by_exid(exid) || (
      raise Evercam::NotFoundError, 'Camera does not exist')
  end

  # Determines if the presented token should be allowed
  # to conduct a particular action on this camera
  def allow?(right, token)
    return true if token &&
      token.grantee == owner

    case right
    when :view
      return true if is_public?
      nil != token && (
        token.allow?("camera:view:#{exid}") ||
        token.allow?("cameras:view:#{owner.username}")
      )
    end
  end

  # The IANA standard timezone for this camera
  # defaulting to UTC if none specified
  def timezone
    Timezone::Zone.new zone:
      (values[:timezone] || 'Etc/UTC')
  end

  # Returns a deep merge of any config values set for this
  # camera with the config of any associated firmware
  def config
    fconf = firmware ? firmware.config : {}
    fconf.deep_merge(values[:config] || {})
  end

  # Returns the location for the camera as a GeoRuby
  # Point if it exists otherwise nil
  def location
    if super
      Point.from_hex_ewkb(super)
    end
  end

  # Sets the cameras location as a GeoRuby Point
  # instance or call with nil to unset
  def location=(val)
    hex_ewkb =
      case val
      when Hash
        Point.from_x_y(
          val[:lng], val[:lat]
        ).as_hex_ewkb
      when Point
        val.as_hex_ewkb
      when nil
        nil
      end

    super(hex_ewkb)
  end

end

