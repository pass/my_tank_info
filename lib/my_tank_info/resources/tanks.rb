# frozen_string_literal: true

module MyTankInfo
  class TanksResource < Resource
    def list(site_id: nil)
      response = get("api/tanks")
      collection = Collection.from_response(response, type: Tank)

      if site_id.nil?
        collection
      else
        collection.select { |tank| tank.site_id == site_id }
      end
    end
  end
end
