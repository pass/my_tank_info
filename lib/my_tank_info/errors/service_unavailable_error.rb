# frozen_string_literal: true

module MyTankInfo
  # Raised when the API's gateway answers with HTTP 502/503/504 — the request
  # never reached the application tier (observed in production as raw IIS
  # "Service Unavailable" HTML pages during brief MyTankInfo outage windows).
  # Subclasses Error so existing `rescue MyTankInfo::Error` handlers keep
  # working, while letting callers treat these as transient (e.g. ActiveJob
  # discard_on/retry_on) instead of falling into UnexpectedResponseError.
  # `status` carries the HTTP status code.
  class ServiceUnavailableError < Error
    attr_reader :status

    def initialize(message = nil, status: nil)
      @status = status
      super(message)
    end
  end
end
