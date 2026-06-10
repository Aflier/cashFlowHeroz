#by default the redirect_uri is set to /auth/xero_oauth2/callback

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :sso, ENV["SSO_APP_ID"], ENV["SSO_APP_SECRET"]
end