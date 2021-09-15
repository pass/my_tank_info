# frozen_string_literal: true

module MyTankInfo
  class Collection
    attr_reader :data

    def self.from_response(response, type:, filter_attribute: nil, filter_value: nil)
      body = response.body

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
    end
  end
end
