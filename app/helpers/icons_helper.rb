module IconsHelper
  def icons__reception_heroz
    raw '<i class="fa-light fa-user-gear fa-fw text-black"></i>'
  end

  def icons__survey
    raw '<i class="fa-light fa-clipboard-list-check"></i>'
  end
  def icons__order_green_circle
    raw '<span class="fa-stack">
    <i class="fas fa-circle fa-stack-2x text-primary"></i>
    <i class="fas fa-sort fa-stack-1x fa-inverse"></i>
  </span>'
  end

  def icons__list
    raw '<i class="fa-light fa-list"></i>'
  end

  def icons__donut
    raw '<i class="fa-light fa-chart-pie"></i>'
  end

  def icons__table_list
    raw '<i class="fa-light fa-table-list"></i>'
  end

  def icons__badge_tick
    raw '<i class="fas fa-badge-check"></i>'
  end

  def icons__badge_empty
    raw '<i class="fal fa-badge"></i>'
  end

  def icons__up_arrow
    raw '<i class="fal fa-arrow-up"></i>'
  end

  def icons__text
    raw '<i class="fal fa-text-size"></i>'
  end

  def icons__ticked(value)
    if value
      raw '<i class="fal fa-check"></i>'
    end
  end

  def icons__order
    raw '<i class="fa-light fa-sort"></i>'
  end



  def icons__calendars
    raw '<i class="fa-light fa-calendars"></i>'
  end

  def icons__unlink
    raw '<i class="far fa-link-slash"></i>'
  end


  def icons__stopwatch(modifier = nil)
    return raw '<i class="fa-kit-duotone fa-duotone-light-timer-circle-exclamation" style="--fa-primary-color: #ff0000; --fa-secondary-color: #ffffff; --fa-secondary-opacity: 1;"></i>' if modifier == :notify

    raw '<i class="fa-light fa-timer"></i>'
  end

  def icons__user
    raw('<i class="fal fa-user fa-fw"></i>')
  end

  def icons__robot(options = {})
    return raw '<i class="fa-light fa-user-robot fa-fade text-dark"></i>' if options[:pulse]

    raw '<i class="fa-light fa-user-robot text-dark"></i>'
  end

  def icons__eraser
    raw '<i class="fas fa-eraser"></i>'
  end

  def icons__scissors
    raw '<i class="fal fa-scissors"></i>'
  end

  def icons__undo
    raw '<i class="fal fa-rotate-left"></i>'
  end

  def icons__download
    raw '<i class="fal fa-download"></i>'
  end

  def icons__connectors(klass = "")
    raw '<i class="fa-sharp fa-light fa-circle-nodes ' + klass + '"></i>'
  end

  def icon__node
    raw '<i class="fa-regular fa-rectangle-wide"></i>'
  end

  def icons__pipe
    raw '<i class="fa-regular fa-pipe ta-fw"></i>'
  end

  def icons__hand_point
    raw '<i class="fa-light fa-hand-point-up"></i>'
  end

  def icons__insert
    raw '<i class="fa-regular fa-arrow-turn-down-right"></i>'
  end

  def icons__hide
    raw '<i class="fa-light fa-eye-slash"></i>'
  end

  def icons__legal_entity
    raw '<i class="fa-fw fa-sharp fa-light fa-scale-balanced"></i>'
  end

  def icons__tick(yaynay)
    raw(yaynay ? icons__check : icons__square)
  end

  def icons__check
    raw '<i class="fa-solid fa-check fa-fw"></i>'
  end

  def icons__cross
    raw '<i class="fa-solid fa-x fa-fw"></i>'
  end

  def icons__diagram
    raw '<i class="fal fa-chart-network"></i>'
  end

  def icons__steps
    raw '<i class="fal fa-shoe-prints"></i>'
  end

  def icons__move
    raw '<i class="fa-sharp fa-light fa-bulldozer"></i>'
  end

  def icons__aflier
    raw '<i class="fa-light fa-kite"></i>'
  end

  def icons__fast
    raw '<i class="fa-light fa-person-running-fast"></i>'
  end

  def icons__goals
    raw '<i class="fa-light fa-route"></i>'
  end

  def icons__backlog
    return "{backlog}" if Rails.env.test?

    raw '<i class="fa-light fa-list"></i>'
  end

  def icons__slide_right
    raw '<i class="fa-kit fa-light-window-maximize-circle-arrow-right"></i>'
  end

  def icons__referral_heroz
    raw '<i class="fa-kit-duotone fa-actionherozfav" style="--fa-primary-color: #0b23c6; --fa-secondary-color: yellow; --fa-secondary-opacity: 1;"></i>'
  end

  def icons__cash_flow_heroz
    raw '<i class="fa-kit-duotone fa-actionherozfav" style="--fa-primary-color: #0b23c6; --fa-secondary-color: black; --fa-secondary-opacity: 1;"></i>'
  end

  def icons__team_heroz
    raw '<i class="fa-kit-duotone fa-actionherozfav" style="--fa-primary-color: #0b23c6; --fa-secondary-color: #00ff00; --fa-secondary-opacity: 1;"></i>'
  end

  def icons__actions
    raw '<i class="fa-kit-duotone fa-actionherozfav" style="--fa-primary-color: #0b23c6; --fa-secondary-color: #56adb9; --fa-secondary-opacity: 1;"></i>'
  end

  def icons__our_score
    raw '<i class="fa-kit fa-os-logo text-danger"></i>'
  end

  def icons__metronome
    raw '<i class="fa-sharp-duotone fa-light fa-user-music"></i>'
  end

  def icons__mission
    return "{mission}" if Rails.env.test?

    raw '<i class="fa-light fa-map-location-dot"></i>'
  end

  def icons__mission_heroz
    image_tag("MissionHerozLogo.svg", width: 20)
  end

  def icons__money_not_recorded
    raw '<div class="badge bg-warning"><i class="fa-light fa-sterling-sign"></i></div>'
  end

  def icons__money_recorded(amount)
    return if amount.nil?

    raw '<div class="badge bg-info">' + amount + "</div>"
  end

  def icons__circle(number, klass = nil)
    return raw '<i class="fa-thin fa-circle"></i>' if number.nil? or number > 9

    raw "<i class='fa-solid fa-circle-#{number} #{klass}'></i>"
  end

  def icons__clock
    raw '<i class="fal fa-user-clock fa-fw"></i>'
  end

  def icons__close
    raw '<i class="fa-solid fa-xmark"></i>'
  end

  def icons__documents
    raw '<i class="fa-light fa-file-contract"></i>'
  end

  def icons__grip_lines
    raw '<i class="fal fa-grip-lines"></i>'
  end

  def icons__must
    raw '<i class="fa-solid fa-circle-m"></i>'
  end

  def icons__should
    raw '<i class="fa-solid fa-circle-s"></i>'
  end

  def icons__could
    raw '<i class="fa-solid fa-circle-c"></i>'
  end

  def icons__wont
    raw '<i class="fa-solid fa-circle-w"></i>'
  end

  def icons__expand
    raw '<i class="fal fa-expand"></i>'
  end

  def icons__edit
    return "{edit}" if Rails.env.test?

    raw '<i class="fal fa-edit"></i>'
  end

  def icons__invoice
    raw '<i class="fa-sharp fa-light fa-file-invoice"></i>'
  end

  def icons__loading
    raw '<i class="fas fa-spinner fa-spin fa-fw"></i>'
  end

  def icons__link(label = nil)
    icon = '<i class="fal fa-external-link"></i>'
    return raw "#{icon} #{label}" if label

    raw icon
  end

  def icons__next
    raw '<i class="fal fa-chevron-right"></i>'
  end

  def icons__sign_out
    return "{sign out}" if Rails.env.test?

    raw '<i class="fas fa-sign-out-alt"></i>'
  end

  def icons__planning
    raw '<i class="fa-sharp fa-regular fa-chart-gantt"></i>'
  end

  def icons__question
    raw '<i class="fal fa-question-circle fa-fw"></i>'
  end

  def icons__print
    raw '<i class="fa-light fa-print"></i>'
  end

  def icons__trash
    return "{trash}" if Rails.env.test?

    raw '<i class="fas fa-trash-alt"></i>'
  end

  def icons__spinner
    raw '<i class="fa-duotone fa-spinner fa-spin"></i>'
  end

  def icons__refresh
    raw '<i class="fal fa-arrows-rotate"></i>'
  end

  def icons__refreshing
    raw '<i class="fal fa-arrows-rotate fa-spin"></i>'
  end

  def icons__toggle_on
    raw '<i class="fa-duotone fa-slider" style="--fa-primary-color: green;"></i>'
  end

  def icons__toggle_off
    raw '<i class="fa-duotone fa-slider fa-rotate-180" style="--fa-primary-color: orangered;"></i>'
  end

  def icons__radio_on
    raw '<i class="far fa-dot-circle"></i>'
  end

  def icons__radio_off
    raw '<i class="far fa-circle"></i>'
  end

  def icons__square
    raw '<i class="fal fa-square"></i>'
  end

  def icons__fast_forward
    return "{fast_forward}" if Rails.env.test?

    raw '<i class="fa-light fa-person-running-fast"></i>'
  end

  def icons__ticked_box
    raw '<i class="fal fa-check-square"></i>'
  end

  def icons__favourite
    raw '<i class="fa-solid fa-star"></i>'
  end

  def icons__not_favourite
    raw '<i class="fa-light fa-star"></i>'
  end

  def icons__clients(tool_tip)
    if tool_tip
      return raw "<i class='fal fa-users' data-bs-toggle='tooltip' data-bs-placement='right' title='#{tool_tip}'></i>"
    end

    raw '<i class="fal fa-users"></i>'
  end

  def icons__progress
    raw '<i class="fa-regular fa-arrow-progress"></i>'
  end

  def icons__schedule
    raw '<i class="fal fa-clipboard-list-check fa-fw"></i>'
  end

  def icons__invoices
    return "{inv}" if Rails.env.test?

    raw '<i class="fal fa-chart-line fa-fw"></i>'
  end

  def icons__client
    raw '<i class="fal fa-user"></i>'
  end

  def icons__pound
    raw '<i class="fal fa-sticky-note fa-fw"></i>'
  end

  def icons__stories
    raw '<i class="fal fa-layer-group fa-fw"></i>'
  end

  def icons__connector_finish
    raw '<i class="fa-light fa-right-to-line"></i>'
  end

  def icons__unlock
    raw '<i class="fa-light fa-lock-open"></i>'
  end

  def icons__connector_start
    raw '<i class="fa-light fa-right-from-line"></i>'
  end

  def icons__plus
    return "{plus}" if Rails.env.test?

    raw '<i class="fa-light fa-plus"></i>'
  end

  def icons__story
    raw '<i class="fal fa-sticky-note fa-fw"></i>'
  end

  def icons__subscriptions
    raw '<i class="fal fa-repeat-alt"></i>'
  end

  def icons__programme
    raw '<i class="fa-regular fa-chart-network"></i>'
  end

  def icons__project
    raw '<i class="fal fa-project-diagram"></i>'
  end

  def icons__requirements
    raw '<i class="fal fa-list-music"></i>'
  end

  def icons__down
    raw '<i class="fal fa-chevron-down"></i>'
  end

  def icons__epic(modifier = nil)
    return "{epic}" if Rails.env.test?

    return raw '<i class="fa-kit fa-light-book-open-cover-pen"></i>' if modifier == :edit

    raw '<i class="fa-light fa-book-open-cover"></i>'
  end

  def icons__epics
    return "{epic}" if Rails.env.test?

    raw '<i class="fa-light fa-books fa-fw"></i>'
  end

  def icons__left
    raw '<i class="fad fa-chevron-double-left"></i>'
  end

  def icons__one_to_many
    raw '<i class="fa-light fa-split"></i>'
  end

  def icons__dashboard
    raw '<i class="fa-light fa-user"></i>'
  end

  def icons__command_centre
    raw '<i class="fa-light fa-globe"></i>'
  end

  def icons__right
    raw '<i class="fad fa-chevron-double-right fa-fw"></i>'
  end

  def icons__danger
    raw '<i class="fa-solid fa-circle-exclamation"></i>'
  end

  def icons__warning
    raw '<i class="fa-solid fa-circle-exclamation"></i>'
  end

  def icons__info
    raw '<i class="fa-solid fa-circle-exclamation"></i>'
  end

  def icons__support
    raw '<i class="fa-sharp fa-solid fa-comments-question-check"></i>'
  end

  # TODO: - Remove this when he know it is no longer needed
  # def icons__help
  #   raw '<i class="fa-solid fa-circle-exclamation"></i>'
  # end

  def icons__success
    raw '<i class="fa-solid fa-circle-exclamation"></i>'
  end

  def icons__arrow_left
    raw '<i class="fa-light fa-left"></i>'
  end

  def icons__arrow_right
    raw '<i class="fa-light fa-right"></i>'
  end

  def icons__trace_in
    raw '<i class="fa-regular fa-arrow-down-to-square fa-rotate-270"></i>'
  end

  def icons__trace_out
    raw '<i class="fa-regular fa-arrow-up-from-square fa-rotate-90"></i>'
  end

  def icons__arrow_down
    raw '<i class="fa-light fa-down"></i>'
  end

  def icons__arrow_up
    raw '<i class="fa-light fa-up"></i>'
  end

  def icons__wizard
    raw '<i class="fa-light fa-wand"></i>'
  end
end
