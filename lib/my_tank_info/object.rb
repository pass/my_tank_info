# frozen_string_literal: true
require "active_support/core_ext/string/inflections"

module MyTankInfo
  class Object
    def initialize(attributes)
      # this ensures that when names are provided in camelcase (BeginDateTime) 
      # they are converted to snake_case (begin_date_time)
      snake_case_keys = attributes&.transform_keys { |key| key.to_s.underscore }
      @attributes = ::OpenStruct.new(snake_case_keys || {})
    end

    def method_missing(method, *args, &block)
      attribute = @attributes.send(method, *args, &block)
      attribute.is_a?(Hash) ? Object.new(attribute) : attribute
    end

    def respond_to_missing?(method, include_private = false)
      true
    end
  end
end
