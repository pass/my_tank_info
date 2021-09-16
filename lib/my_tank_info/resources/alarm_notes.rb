# frozen_string_literal: true

module MyTankInfo
  class AlarmNotesResource < Resource
    def create(alarm_id:, **attributes)
      AlarmNote.new post_request("api/alarmhistory/#{alarm_id}/notes", body: attributes).body
    end

    def delete(alarm_id:, note_id:)
      delete_request("api/alarmhistory/#{alarm_id}/notes/#{note_id}")
    end
  end
end
