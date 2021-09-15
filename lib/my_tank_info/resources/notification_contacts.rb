# frozen_string_literal: true

module MyTankInfo
  class NotificationContactsResource < Resource
    def list
      response = get("api/admin/notificationcontacts")
      Collection.from_response(response, type: NotificationContact)
    end

    def list_sites(contact_id:)
      response = get("api/admin/notificationcontacts/#{contact_id}/sites")
      Collection.from_response(response, type: NotificationSite)
    end

    def retrieve(contact_id:)
      NotificationContact.new get("api/admin/notificationcontacts/#{contact_id}").body
    end

    def update(contact_id:, **attributes)
      request = put("api/admin/notificationcontacts/#{contact_id}", body: attributes)
      NotificationContact.new request.body
    end

    def create(**attributes)
      NotificationContact.new post("api/admin/notificationcontacts", body: attributes).body
    end

    def delete(contact_id:)
      NotificationContact.new delete_request("api/admin/notificationcontacts/#{contact_id}").body
    end
  end
end
