module ConnectionControl
  extend ActiveSupport::Concern

  def update_connecting
    @user = User.find(params[:id])
    @user.set_filter(:finish_id, params[:finish_id].to_i) if params[:finish_id].present?
    @user.set_filter(:finish_type, params[:finish_type]) if params[:finish_type].present?
    @user.set_filter(:start_id, params[:start_id].to_i) if params[:start_id].present?
    @user.set_filter(:start_type, params[:start_type]) if params[:start_type].present?

    @connector = @user.send_connection
    @user.reload
    @user.update_connector
  end

  def refresh_connection
    @user = User.find(params[:id])
    @user.set_filter(:finish_id, nil)
    @user.set_filter(:finish_type, nil)
    @user.set_filter(:start_id, nil)
    @user.set_filter(:start_type, nil)

    @user.update_connector
  end

  def connector_preview
    @user = User.find(params[:id])
    @connector_uuid = params[:connector_uuid]
    @connector_type = params[:connector_type]

    @user.set_filter(:connector_uuid, @connector_uuid)
    @user.set_filter(:connector_type, @connector_type)

    return if @connector_uuid.blank?

    @show_holder = true if params[:show_holder] == "true"

    @node = Object.const_get(params[:klass]).find(params[:klass_id])

    return if @show_holder

    case @connector_type
    when "Activity"
      response = RestClient.get "#{$our_score_url}/api/v001/activities/#{@connector_uuid}/details"
      @rendered = JSON.parse(response)
      @purpose = @rendered["purpose"]
      @rendered = @rendered["activity"]
    when "Prop"
      response = RestClient.get "#{$our_score_url}/api/v001/props/#{@connector_uuid}/details"
      @rendered = JSON.parse(response)
      @rendered = @rendered["prop"]
    when "Role"
      response = RestClient.get "#{$our_score_url}/api/v001/roles/#{@connector_uuid}/details"
      @rendered = JSON.parse(response)
      @rendered = @rendered["role"]
    when "Ticket"
      response = RestClient.get "#{$action_heroz_url}/api/v001/actions/#{@connector_uuid}/details"
      @rendered = JSON.parse(response)
      @rendered = @rendered["ticket"]
    when "Story"
      response = RestClient.get "#{$mission_heroz_url}/api/v001/stories/#{@connector_uuid}/preview"
      @rendered = JSON.parse(response)
      @rendered = @rendered["story"]
    when "WorkPackage"
      response = RestClient.get "#{$mission_heroz_url}/api/v001/work_packages/#{@connector_uuid}/preview"
      @rendered = JSON.parse(response)
      @title = @rendered["title"]
      @rendered = @rendered["preview"]
    when "Project"
      response = RestClient.get "#{$mission_heroz_url}/api/v001/projects/#{@connector_uuid}/preview"
      @rendered = JSON.parse(response)
      @title = @rendered["title"]
      @rendered = @rendered["preview"]
    when "Contact"
      response = RestClient.get "#{$referral_heroz_url}/api/v001/contacts/#{@connector_uuid}/preview"
      @rendered = JSON.parse(response)
      @title = @rendered["title"]
      @rendered = @rendered["preview"]
    when 'Dashboard'
      response = RestClient.get "#{$metronome_url}/api/v001/dashboards/#{@connector_uuid}/preview"
      @rendered = JSON.parse(response)
      @title = @rendered['title']
      @rendered = @rendered['preview']
    when 'ReportType'
      response = RestClient.get "#{$action_heroz_url}/api/v001/action_types/#{@connector_uuid}/preview"
      @rendered = JSON.parse(response)
      @title = @rendered['title']
      @rendered = @rendered['preview']
    else
      # do nothing
    end
  end

  def remove_connector
    @user = User.find(params[:id])
    @user.remove_sso_connector(params[:connector_uuid])
  end

  def update_connector
    @user = User.find(params[:id])
    @user.update_sso_connector(params[:connector_uuid], params[:connector])
  end
end
