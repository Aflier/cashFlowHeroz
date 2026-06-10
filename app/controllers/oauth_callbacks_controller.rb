class OauthCallbacksController < ApplicationController
  # before_action :authenticate_sso_user, only: [:destroy] start to use new way of doing it below
  allow_unauthenticated_access only: %i[ create ]
  rate_limit to: 10, within: 3.minutes, only: :create

  # omniauth callback method
  #
  # First the callback operation is done
  # inside OmniAuth and then this route is called
  def create
    if params[:provider] == "sso"
      auth_hash = request.env["omniauth.auth"]
      @user = User.from_omniauth(auth_hash)

      if @user.persisted?
        # This is the native Rails 8 helper to log the user in
        start_new_session_for(@user)
        redirect_to after_authentication_url, notice: "Successfully signed in!"
      else

      end

      # Currently storing all the info
      session[:user_id] = auth_hash

      flash[:notice] = "Successfully logged in"
      # redirect_to root_path
    end
  end

  # Omniauth failure callback
  def failure
    flash[:notice] = params[:message]
  end

  # logout - Clear our rack session BUT essentially redirect to the provider
  # to clean up the Devise session from there too !
  def destroy
    terminate_session
    redirect_to "#{ENV["SSO_PROVIDER_URL"]}/users/sign_out", allow_other_host: true
  end
end
