module ApplicationHelper
  def btn_logout
    return unless authenticated?

    button_to logout_path,
              method: :delete,
              data: { turbo: false },
              class: "px-1 fa-2x  sm:flex no-underline" do
      raw("#{icons__sign_out} Sign Out")
    end
  end

  def bootstrap__close_modal
    turbo_stream.replace :remote_modal do
      turbo_frame_tag :remote_modal
    end
  end

  def suite_links(user)
    url = "#{$sso_url}/api/v001/suite_links"
    url = "#{$sso_url}/api/v001/users/#{user.uid}/slices" if user
    response = RestClient.get(url)
    response = JSON.parse(response)
    response['links']
  end
end
