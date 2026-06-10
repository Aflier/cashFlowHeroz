module Connectable
  extend ActiveSupport::Concern

  included do
    serialize :connectors_store, coder: YAML, type: Hash

    def end_here_connectors
      if connectors_store.empty?
        fetch_sso_to_connectors
        fetch_sso_from_connectors
      end

      return [] if connectors_store[:end].nil?

      connectors_store[:end]
    end

    def fetch_sso_to_connectors
      return [] if Rails.env.test?

      response = RestClient.get("#{$sso_url}/api/v001/connectors/get_to_connectors?toable_uuid=#{uuid}&toable_type=#{self.class.name}")
      response = JSON.parse(response)

      connectors_store[:end] = response['connectors']
      save
      response['connectors']
    end

    def start_here_connectors
      if connectors_store.empty?
        fetch_sso_to_connectors
        fetch_sso_from_connectors
      end
      return [] if connectors_store[:start].nil?

      connectors_store[:start]
    end

    def fetch_sso_from_connectors
      return [] if Rails.env.test?

      response = RestClient.get("#{$sso_url}/api/v001/connectors/get_from_connectors?fromable_uuid=#{uuid}&fromable_type=#{self.class.name}")
      response = JSON.parse(response)

      connectors_store[:start] = response['connectors']
      save
      response['connectors']
    end

    # Get warnings on the connectors we are pointing at
    def to_warnings; end
    def from_warnings; end

    def start_style(connector)
      connector[:bg_style]
    end

    def connector_style
      'bg-info-subtle'
    end

    def end_style(connector)
      # end styles
    end

    def specific_sso_to_connectors(type)
      end_here_connectors.select { |connector| connector['fromable_type'] == type }
    end

    def specific_sso_from_connectors(type)
      start_here_connectors.select { |connector| connector['toable_type'] == type }
    end
  end
end
