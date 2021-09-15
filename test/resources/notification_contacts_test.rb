# frozen_string_literal: true

require "test_helper"

class NotificationContactsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "api/admin/notificationcontacts",
        response: stub_response(fixture: "notification_contacts/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.notification_contacts.list

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::NotificationContact, results.data.first.class
  end

  def test_list_sites
    stub =
      stub_request(
        "api/admin/notificationcontacts/#{CONTACT_ID}/sites",
        response: stub_response(fixture: "notification_sites/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.notification_contacts.list_sites(contact_id: CONTACT_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::NotificationSite, results.data.first.class
  end

  def test_retrieve
    stub =
      stub_request(
        "api/admin/notificationcontacts/#{CONTACT_ID}",
        response: stub_response(fixture: "notification_contacts/retrieve")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    contact = client.notification_contacts.retrieve(contact_id: CONTACT_ID)

    assert_equal MyTankInfo::NotificationContact, contact.class
    assert_equal "Kyle Keesling", contact.full_name
  end

  def test_update
    body = {first_name: "Kyle"}
    stub =
      stub_request(
        "api/admin/notificationcontacts/#{CONTACT_ID}",
        method: :put,
        body: body,
        response: stub_response(fixture: "notification_contacts/retrieve")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.notification_contacts.update(contact_id: CONTACT_ID, **body)
  end

  def test_create
    body = {
      first_name: "Raymond",
      last_name: "Rees",
      email: "raymond@example.com",
      sms_phone: "555-555-5555",
      contact_method: 3,
      is_active: true
    }

    stub =
      stub_request(
        "api/admin/notificationcontacts",
        method: :post,
        body: body,
        response: stub_response(fixture: "notification_contacts/create")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    contact = client.notification_contacts.create(**body)

    assert_equal MyTankInfo::NotificationContact, contact.class
    assert_equal "raymond@example.com", contact.email
  end

  def test_delete
    stub =
      stub_request(
        "api/admin/notificationcontacts/#{CONTACT_ID}",
        method: :delete,
        response: stub_response(fixture: "notification_contacts/delete")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    contact = client.notification_contacts.delete(contact_id: CONTACT_ID)

    assert_equal MyTankInfo::NotificationContact, contact.class
  end
end
