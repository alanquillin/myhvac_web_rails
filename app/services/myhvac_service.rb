class MyhvacService
  include HTTParty

  base_uri Settings.myhvac_service.base_uri

  def system_status
    self.get('/system/state', Settings.myhvac_service.default_fake_state)
  end

  def get(path, fake=nil)
    if Settings.myhvac_service.fake
      Rails.logger.debug "myhvac_service: Using FAKE data: #{fake}"
      return fake
    end

    Rails.logger.debug "myhvac_service request: GET http://#{Settings.myhvac_service.base_uri}#{path}"
    resp = self.class.get(path)
    Rails.logger.debug "myhvac_service response: #{resp}"
    resp
  end
end