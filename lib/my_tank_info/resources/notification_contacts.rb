# frozen_string_literal: true

module MyTankInfo
  class NotificationContactsResource < Resource
    def list
      response = get_request("api/admin/notificationcontacts")
      Collection.from_response(response, type: NotificationContact)
    end

    def list_sites(contact_id:)
      response = get_request("api/admin/notificationcontacts/#{contact_id}/sites")
      Collection.from_response(response, type: NotificationSite)
    end

    def retrieve(contact_id:)
      NotificationContact.new get_request("api/admin/notificationcontacts/#{contact_id}").body
    end

    def update(contact_id:, **attributes)
      request = put_request("api/admin/notificationcontacts/#{contact_id}", body: attributes)
      NotificationContact.new request.body
    end

    def create(**attributes)
      NotificationContact.new post_request("api/admin/notificationcontacts", body: attributes).body
    end

    def delete(contact_id:)
      delete_request("api/admin/notificationcontacts/#{contact_id}")
    end
  end
end
