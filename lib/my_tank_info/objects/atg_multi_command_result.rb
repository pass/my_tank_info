# frozen_string_literal: true

module MyTankInfo
  class AtgMultiCommandResult < Object
    # Each entry is {sequence:, command:, response:} — wrap so callers get
    # the same dot-access as every other gem object.
    def results
      Array(@attributes[:results]).map { |result| Object.new(result) }
    end

    def response_for(command)
      results.find { |result| result.command.to_s.casecmp?(command.to_s) }&.response
    end
  end
end
