# frozen_string_literal: true

require "test_helper"

class NotificationRulesResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "api/admin/notificationrules",
        response: stub_response(fixture: "notification_rules/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.notification_rules.list(code_id: NOTIFICATION_CODE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::NotificationRule, results.data.first.class
  end

  def test_list_contacts
    stub =
      stub_request(
        "api/admin/notificationrules/#{NOTIFICATION_RULE_ID}/contacts",
        response: stub_response(fixture: "notification_rule_contacts/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.notification_rules.list_contacts(rule_id: NOTIFICATION_RULE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::NotificationRuleContact, results.data.first.class
  end

  def test_list_codes
    stub =
      stub_request(
        "api/admin/notificationrules/codes",
        response: stub_response(fixture: "notification_codes/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.notification_rules.list_codes

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::NotificationCode, results.data.first.class
  end

  def test_update
    body = {
      id: NOTIFICATION_RULE_ID,
      isSuppressed: false,
      contacts: [
        {
          contactId: 201,
          contactMethod: 2
        }
      ]
    }

    stub =
      stub_request(
        "api/admin/notificationrules/#{NOTIFICATION_RULE_ID}",
        method: :put,
        body: body,
        response: stub_response(fixture: "notification_rules/update")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.notification_rules.update(rule_id: NOTIFICATION_RULE_ID, **body)
  end

  def test_delete
    stub =
      stub_request(
        "api/admin/notificationrules/#{CONTACT_ID}",
        method: :delete,
        response: stub_response(fixture: "notification_rules/delete")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.notification_rules.delete(rule_id: CONTACT_ID)
  end
end
