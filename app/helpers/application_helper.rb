module ApplicationHelper
  def btn_logout
    return unless authenticated?

    button_to icons__sign_out,
              logout_path,
              method: :delete,
              data: { turbo: false },
              class: "pw-full sm:w-auto rounded-md px-3.5 py-2.5 hover:bg-blue-500 text-white inline-block font-medium cursor-pointer"
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
