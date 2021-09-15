# frozen_string_literal: true

module MyTankInfo
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def get_request(url, params: {}, headers: {})
      handle_response client.connection.get(url, params, default_headers.merge(headers))
    end

    def post_request(url, body:, headers: {})
      handle_response client.connection.post(url, body, default_headers.merge(headers))
    end

    def patch_request(url, body:, headers: {})
      handle_response client.connection.patch(url, body, default_headers.merge(headers))
    end

    def put_request(url, body:, headers: {})
      handle_response client.connection.put(url, body, default_headers.merge(headers))
    end

    def delete_request(url, params: {}, headers: {})
      handle_response client.connection.delete(url, params, default_headers.merge(headers))
    end

    private

    def default_headers
      {Authorization: "Bearer #{client.api_key}"}
    end

    def handle_response(response)
      message = response.reason_phrase

      case response.status
      when 400
        raise Error, message
      when 401
        raise Error, message
      when 403
        raise Error, message
      when 404
        raise Error, [response.status, message, "This resource could not be found"].join(" - ")
      when 429
        raise Error, message
      when 500
        raise Error, message
      end

      response
    end
  end
end
