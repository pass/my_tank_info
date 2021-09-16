# frozen_string_literal: true

module MyTankInfo
  class TanksResource < Resource
    def list(site_id: nil)
      response = get_request("api/tanks")

      if site_id.nil?
        Collection.from_response(response, type: Tank)
      else
        Collection.from_response(
          response,
          type: Tank,
          filter_attribute: :site_id,
          filter_value: site_id
        )
      end
    end

    def retrieve(tank_id:)
      Tank.new get_request("api/tanks/#{tank_id}").body
    end
  end
end
