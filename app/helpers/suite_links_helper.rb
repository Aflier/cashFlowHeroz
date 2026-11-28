# WARNING: Do not update this page, update in ActionHeroz and then copy the file here

module SuiteLinksHelper
  def btn_logout
    return unless authenticated? # user_signed_in? if using older version of rails

    button_to logout_path,
              method: :delete,
              data: { turbo: false },
              class: "px-1 fa-2x align-middle no-underline w-full" do
      raw("#{icons__sign_out} Sign Out")
    end
  end

  def suite_links(user)
    url = "#{$sso_url}/api/v001/suite_links"
    url = "#{$sso_url}/api/v001/users/#{user.uid}/slices" if user
    puts ">>>>>> RESPONSE: #{url}"
    response = RestClient.get(url)

    response = JSON.parse(response)
    response["links"]
  end
end
