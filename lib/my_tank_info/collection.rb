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

      # An array body can still hold non-object elements (the alternate
      # endpoint's dailyusage returns a bare array of floats). Building
      # records from those raises an opaque NoMethodError inside Object, so
      # reject them here with the same diagnosable error as above.
      unless body.all? { |attrs| attrs.is_a?(Hash) }
        raise UnexpectedResponseError,
          "Expected an array of JSON objects from the API but got " \
          "#{body.map(&:class).uniq.join(", ")} elements (HTTP #{response.status}) - " \
          "#{MyTankInfo.truncate_error_body(body.inspect)}"
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
