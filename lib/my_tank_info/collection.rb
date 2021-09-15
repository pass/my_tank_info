# frozen_string_literal: true

module MyTankInfo
  class Collection
    attr_reader :data, :size

    def self.from_response(response, type:, filter_attribute: nil, filter_value: nil)
      body =
        if response.body.instance_of?(Hash)
          [response.body]
        else
          response.body
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
