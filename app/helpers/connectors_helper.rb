module ConnectorsHelper

  def connector_fromable_content(connector)
    # todo: add content here
  end

  def connectors_frame_path(path, options: {})
    token = Rails.application.message_verifier(:connectors_options).generate(options)
    "#{path}?options_token=#{CGI.escape(token)}"
  end

end
