# frozen_string_literal: true

module MyTankInfo
  class TanksResource < Resource
    def list(**params)
      response = get("api/tanks", params: params)
      Collection.from_response(response, type: Tank)
    end
  end
end
