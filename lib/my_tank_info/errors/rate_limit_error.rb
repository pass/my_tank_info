# frozen_string_literal: true

module MyTankInfo
  # Raised when the API responds with HTTP 429 (rate limit exceeded).
  # Subclasses Error so existing `rescue MyTankInfo::Error` handlers keep
  # working, while letting callers target rate limiting specifically (e.g.
  # ActiveJob retry_on). `retry_after` carries the Retry-After header as
  # seconds when the API provides one, nil otherwise.
  class RateLimitError < Error
    attr_reader :retry_after

    def initialize(message = nil, retry_after: nil)
      @retry_after = retry_after
      super(message)
    end
  end
end
