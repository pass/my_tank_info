# frozen_string_literal: true

module MyTankInfo
  class NotificationRule < Object
    def contacts
      @attributes.contacts.map { |contact| NotificationContact.new(contact) }
    end
  end
end
