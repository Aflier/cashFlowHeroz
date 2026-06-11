if Rails.env.production?
  $sso_url = 'https://reception.heroz.app'
  $sso_app_uuid = 'ec07a498b2e6010be541e9c65dde2da9'
  $sso_app_secret = '75d2b4c427f2c85f634ab4f08556fe26'
  AI_OVERLORD = 'https://ai-overlord-5f598b872212.herokuapp.com'
  $mission_heroz_url = "https://mission.heroz.app"
  $action_heroz_url = "https://action.heroz.app"
  $website_heroz_url = "https://website.heroz.app"
  $team_heroz_url = "https://team.heroz.app"
  $our_score_url = "https://www.ourscore.business"
  $metronome_url = "https://metronome.ourscore.business"
  $referral_heroz_url = "https://referral.heroz.app"
  $meeting_heroz_url = "https://meeting.heroz.app"
  $asset_flow_heroz_url = "https://asset.heroz.app"
  $cash_flow_heroz_url = "https://cash.heroz.app"
else
  $sso_url = 'http://localhost:3009'
  $sso_app_uuid = 'ABC'
  $sso_app_secret = 'DEF'
  AI_OVERLORD = 'http://localhost:3004'
  $mission_heroz_url = "http://localhost:3000"
  $action_heroz_url = "http://localhost:3002"
  $website_heroz_url = "http://localhost:3003"
  $team_heroz_url = "http://localhost:3005"
  $our_score_url = "http://localhost:3008"
  $metronome_url = "http://localhost:3007"
  $referral_heroz_url = "http://localhost:3006"
  $meeting_heroz_url = "http://localhost:3010"
  $asset_flow_heroz_url = "http://localhost:3011"
  $cash_flow_heroz_url = "http://localhost:3012"
end
