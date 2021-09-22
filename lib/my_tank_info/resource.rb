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

    def enforce_required_attributes(required_attrs:, attrs:)
      attr_keys = attrs.keys
      required_attrs_present = required_attrs.all? { |req_attr| attr_keys.include?(req_attr) }

      unless required_attrs_present
        missing_attrs = required_attrs - attr_keys
        error_message = "You must provide values for all required attributes: #{missing_attrs.join(", ")}"
        raise MissingRequiredAttributeError, error_message
      end
    end

    def default_headers
      {Authorization: "Bearer #{client.api_key}"}
    end

    def handle_response(response)
      message = response.body

      case response.status
      when 400
        raise Error, "Your request was malformed - #{message}"
      when 401
        raise UnauthorizedError, "You did not supply valid authentication credentials - #{message}"
      when 403
        raise RequestForbiddenError, "You are not allowed to perform that action - #{message}"
      when 404
        raise Error, "This resource could not be found"
      when 429
        raise Error, "Your request exceeded the API rate limit - #{message}"
      when 500
        raise InternalServerError, "We were unable to perform the request due to server-side problems - #{message}"
      end

      response
    end
  end

  class UnauthorizedError < Error; end

  class MissingRequiredAttributeError < Error; end

  class RequestForbiddenError < Error; end

  class InternalServerError < Error; end
end
