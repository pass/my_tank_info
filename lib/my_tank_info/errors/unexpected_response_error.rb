# frozen_string_literal: true

module MyTankInfo
  # Raised when the API returns a response we don't know how to handle - an
  # unexpected HTTP status, or a body that isn't the JSON object/array the
  # caller expects (e.g. an HTML error page from a proxy, or an empty/plain
  # text body). The message captures the status code and (truncated) body so
  # the failure can actually be diagnosed instead of surfacing as a generic
  # `NoMethodError` deeper in the stack.
  class UnexpectedResponseError < Error; end
end
