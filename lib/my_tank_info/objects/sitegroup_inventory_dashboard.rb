# frozen_string_literal: true

module MyTankInfo
  class SitegroupInventoryDashboard < Object
    def sites
      @attributes.sites.map { |site| Site.new(site) }
    end
  end
end
