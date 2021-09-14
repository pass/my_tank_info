# frozen_string_literal: true

module MyTankInfo
  class Collection
    attr_reader :data

    def self.from_response(response, type:)
      body = response.body

      @collection =
        new(
          data: body.map { |attrs| type.new(attrs) }
        )

      @collection.data
    end

    def initialize(data:)
      @data = data
    end
  end
end
