# frozen_string_literal: true

module MyTankInfo
  class SitesResource < Resource
    def poll_inventory(site_id:)
      post_request("api/sites/#{site_id}/pollnow/", body: {})
    end
  end
end
