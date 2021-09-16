# frozen_string_literal: true

require "test_helper"

class AlarmHistoryNotesResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/alarmhistory/#{ALARM_ID}/notes",
        response: stub_response(fixture: "alarm_notes/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    alarm_notes = client.alarm_history_notes.list(alarm_id: ALARM_ID)

    assert_equal MyTankInfo::Collection, alarm_notes.class
    assert_equal MyTankInfo::AlarmNote, alarm_notes.data.first.class
  end

  def test_create
    body = {
      note: "Test Note"
    }

    stub =
      stub_request(
        "/api/alarmhistory/#{ALARM_ID}/notes",
        method: :post,
        body: body,
        response: stub_response(fixture: "alarm_notes/create")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    contact = client.alarm_history_notes.create(alarm_id: ALARM_ID, **body)

    assert_equal MyTankInfo::AlarmNote, contact.class
  end

  def test_delete
    stub =
      stub_request(
        "/api/alarmhistory/#{ALARM_ID}/notes/#{ALARM_NOTE_ID}",
        method: :delete,
        response: stub_response(fixture: "alarm_notes/delete")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.alarm_history_notes.delete(alarm_id: ALARM_ID, note_id: ALARM_NOTE_ID)
  end
end
