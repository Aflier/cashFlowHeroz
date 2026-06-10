module ConnectorModel
  extend ActiveSupport::Concern

  included do
    # models to add
    CONNECTORS_TO_REFRESH = %w[].freeze

    def has_connector_finish?
      true unless filter(:finish_type).blank?
    end

    def has_connector_start?
      true unless filter(:start_type).blank?
    end

    def send_connection
      finish = filter(:finish_id)
      start = filter(:start_id)

      from_instance = Object.const_get(filter(:start_type)).find(start) if start
      to_instance = Object.const_get(filter(:finish_type)).find(finish) if finish

      if from_instance
        from_name = from_instance.ident_number if from_instance
        from_description = from_instance.connection_description
        start_bg_style = from_instance.connector_style
      end
      if to_instance
        to_name = to_instance.ident_number if to_instance
        to_description = to_instance.connection_description
        finish_bg_style = to_instance.connector_style
      end

      RestClient.post("#{$sso_url}/api/v001/connectors",
                      { uid: uid,
                        connector: {
                          toable_name: to_name,
                          toable_type: to_instance&.class&.name,
                          toable_uuid: to_instance&.uuid,
                          toable_description: to_description,
                          finish_bg_style: finish_bg_style,
                          fromable_name: from_name,
                          fromable_type: from_instance&.class&.name,
                          fromable_uuid: from_instance&.uuid,
                          fromable_description: from_description,
                          start_bg_style: start_bg_style
                        } })
    end

    def remove_sso_connector(connector_uuid)
      return if connector_uuid.blank?

      RestClient.delete("#{$sso_url}/api/v001/connectors/#{connector_uuid}?uid=#{uid}",
                        { uid: uid })
    end

    def update_sso_connector(connector_uuid, params)
      return if connector_uuid.blank?
      params = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params

      RestClient.patch("#{$sso_url}/api/v001/connectors/#{connector_uuid}",
                       { uid: uid, connector: params })
    end

    def update_connector
      broadcast_replace target: :connector_nav,
                        partial: 'layouts/connector/connector_nav',
                        locals: { user: self }
    end

    def update_node(node)
      # Fetch the connectors for this node.
      node.fetch_sso_to_connectors
      node.fetch_sso_from_connectors

      # todo: set the correct path and uncomment

      path = "#{$cash_flow_heroz_url}/#{node.class.name.underscore.pluralize}/#{node.id}/connectors"
      broadcast_replace target: "connectors_#{node.class.name.underscore}_#{node.id}",
                        partial: 'connectors/connectors_frame',
                        locals: { node: node, path: path }
    end
  end
end
