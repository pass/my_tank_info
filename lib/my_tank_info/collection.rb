# frozen_string_literal: true

module MyTankInfo
  class Collection
    attr_reader :data, :size

    def self.from_response(response, type:, filter_attribute: nil, filter_value: nil)
      body =
        case response.body
        when Hash
          [response.body]
        when Array
          response.body
        else
          # A successful status with a body that isn't the JSON object/array we
          # expect (e.g. an empty or plain-text body). Calling `.map` on it
          # would raise an opaque NoMethodError - capture the status and body
          # so the unexpected response is diagnosable.
          raise UnexpectedResponseError,
            "Expected a JSON object or array from the API but got " \
            "#{response.body.class} (HTTP #{response.status}) - " \
            "#{MyTankInfo.truncate_error_body(response.body)}"
        end

      @collection = new(
        data: body.map { |attrs| type.new(attrs) },
        filter_attribute: filter_attribute,
        filter_value: filter_value
      )
    end

    def initialize(data:, filter_attribute: nil, filter_value: nil)
      @data =
        if filter_attribute && filter_value
          data.select { |item| item.send(filter_attribute) == filter_value }
        else
          data
        end

      @size = @data.size
    end
  end
end
