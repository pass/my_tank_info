# frozen_string_literal: true
require "active_support/core_ext/string/inflections"

module MyTankInfo
  class Object
    def initialize(attributes)
      # this ensures that when names are provided in camelcase (BeginDateTime)
      # they are converted to snake_case (begin_date_time)
      @original_attributes = attributes
      @attributes = without_null_bytes(attributes || {}).transform_keys { |key| key.to_s.underscore.to_sym }
    end

    def method_missing(method, *args, &block)
      key = method.to_sym
      value = @attributes[key]
      value.is_a?(Hash) ? Object.new(value) : value
    end

    def respond_to_missing?(method, include_private = false)
      true
    end

    # The parsed attributes with string keys, for callers that want to
    # persist the payload as received. Defined explicitly because
    # method_missing would otherwise answer to_h with nil.
    def to_h
      @attributes.transform_keys(&:to_s)
    end

    private

    # MyTankInfo passes ATG text through as-is, and some ATGs pad it with NUL
    # bytes, which Postgres text columns reject.
    def without_null_bytes(value)
      case value
      when String then value.delete("\0")
      when Hash then value.transform_values { |v| without_null_bytes(v) }
      when Array then value.map { |v| without_null_bytes(v) }
      else value
      end
    end
  end
end
