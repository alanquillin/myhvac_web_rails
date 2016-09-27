class MyhvacService
  include HTTParty

  base_uri Settings.myhvac_service.base_uri

  def system_state
    self.get('/system/state', Settings.myhvac_service.default_fake_state)
  end

  def get(path, fake=nil)
    if Settings.myhvac_service.fake
      return fake
    end

    self.class.get(path)
  end
end