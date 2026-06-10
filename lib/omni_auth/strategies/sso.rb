require "omniauth-oauth2"
module OmniAuth
  module Strategies
    class Sso < OmniAuth::Strategies::OAuth2

      provider_url = ENV.fetch("SSO_PROVIDER_URL")

      option :client_options, {
        site: provider_url,
        authorize_url: URI.join(provider_url, "/auth/sso/authorize").to_s,
        access_token_url: URI.join(provider_url, "/auth/sso/access_token").to_s
      }

      uid do
        raw_info["id"]
      end

      info do
        {
          email: raw_info["info"]["email"],
          name: raw_info["info"]["name"],
        }
      end

      extra do
        {
          first_name: raw_info["extra"]["first_name"],
          last_name: raw_info["extra"]["last_name"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/auth/sso/user.json?oauth_token=#{access_token.token}&bob=0").parsed
      end
    end
  end
end
