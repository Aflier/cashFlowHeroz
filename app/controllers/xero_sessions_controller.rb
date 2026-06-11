
# app/controllers/xero_sessions_controller.rb
class XeroSessionsController < ApplicationController
  # Step A: Redirect the user to Xero's authorization screen
  # GET /xero/connect
  def connect
    xero_client = initialize_xero_client

    # FIX: Call the method with zero arguments as expected by the SDK
    authorization_url = xero_client.authorization_url

    redirect_to authorization_url, allow_other_host: true
  end

  # Step B: Handle the callback from Xero after user consent
  # GET /xero/callback
  def callback
    # 1. Catch validation errors or user cancellations
    if params[:error].present?
      flash[:error] = "Xero Authorization Failed: #{params[:error_description]}"
      return redirect_to root_path
    end

    xero_client = initialize_xero_client

    begin
      # 2. Exchange the temporary URL authorization code for official API access tokens
      token_set = xero_client.get_token_set_from_callback(params)

      # 3. Retrieve the connected Xero Organisation ID (Tenant ID)
      # A single login can have multiple authorized organizations; grab the first active one
      connections = xero_client.connections
      active_connection = connections.find { |c| c["tenantType"] == "ORGANISATION" }

      if active_connection.nil?
        flash[:error] = "No active Xero organization connection found."
        return redirect_to root_path
      end

      tenant_id = active_connection["tenantId"]

      # 4. Save or update the tokens in your database for background workers to use
      mission = Mission.find_by(tenant_id: tenant_id)

puts ">>>>>>>>> #{mission.name}"

      mission.update!(
        access_token: token_set["access_token"],
        refresh_token: token_set["refresh_token"],
        expires_at: Time.at(token_set["expires_at"])
      )

      flash[:notice] = "Successfully connected to Xero organization!"
      redirect_to root_path

    rescue XeroRuby::ApiError => e
      flash[:error] = "Failed to retrieve tokens from Xero: #{e.message}"
      redirect_to root_path
    end
  end

  private

  # Centralised configuration helper for the Xero Ruby SDK client
  def initialize_xero_client
    XeroRuby::ApiClient.new(credentials: {
      client_id: "6BA15BB4624A4F6FAC746B1B302B745B",
      client_secret: "-Z6LPwWU-LD3cmuCEchlkPxYLoTz-vOkVqsTYkvVkH8tQVMM",
      redirect_uri: "https://cash.heroz.app/xero/callback",
      scopes: "openid profile email accounting.invoices.read offline_access"
    })
  end
end



#      client_id: "A2A6438EF0474E849498A5725D407E9D",
#      client_secret: "MP1JXABIEBfMLurERFECFGfdze6Tu3Gteno2Ht9f0sLI97lX",
#      redirect_uri: "https://portal.aflier.com/auth/xero_oauth2/callback"
