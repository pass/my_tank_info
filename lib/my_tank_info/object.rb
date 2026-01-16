# frozen_string_literal: true
require "active_support/core_ext/string/inflections"

module MyTankInfo
  class Object
    def initialize(attributes)
      @original_attributes = attributes

      # this ensures that when names are provided in camelcase (BeginDateTime)
      # they are converted to snake_case (begin_date_time)
      @attributes = Hash(attributes).transform_keys { |key| key.to_s.underscore.to_sym }
    end

    def method_missing(method, *args, &block)
      attribute = @attributes[method]
      attribute.is_a?(Hash) ? Object.new(attribute) : attribute
    end

    def respond_to_missing?(method, include_private = false)
      @attributes.key?(method)
    end
  end
end
