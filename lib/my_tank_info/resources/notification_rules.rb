# frozen_string_literal: true

module MyTankInfo
  class NotificationRulesResource < Resource
    def list_codes
      response = get_request("api/admin/notificationrules/codes")
      Collection.from_response(response, type: NotificationCode)
    end

    def list_contacts(rule_id:)
      response = get_request("api/admin/notificationrules/#{rule_id}/contacts")
      Collection.from_response(response, type: NotificationRuleContact)
    end

    def list(code_id:)
      response = get_request("api/admin/notificationrules?codeId=#{code_id}")
      Collection.from_response(response, type: NotificationRule)
    end

    def update(rule_id:, **attributes)
      put_request("api/admin/notificationrules/#{rule_id}", body: attributes)
    end

    def delete(rule_id:)
      delete_request("api/admin/notificationrules/#{rule_id}")
    end
  end
end
