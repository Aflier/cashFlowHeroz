module ConnectableControl
  extend ActiveSupport::Concern

  def connectors
    render partial: 'connectors/connectors', locals: { node: @connectable, options: options_from_token }
  end

  private

  def options_from_token
    token = params[:options_token]
    if token.blank?
      return {
        include_start_description: true
      }
    end

    Rails.application.message_verifier(:connectors_options).verify(token).deep_symbolize_keys
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    {}
  end
end
