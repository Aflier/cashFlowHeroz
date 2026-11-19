# WARNING: Do not update this page, update in ActionHeroz and then copy the file here

module SharedIconsHelper
  def action_badge(ticket)
    link_to ticket_url(ticket), class: 'action-badge-sm' do
      ident_pretty(ticket.ident_number)
    end
  end

  def ident_pretty(ident_number)
    with_icon = ident_number.gsub('AH', "#{icons__action} ")
    with_icon = with_icon.gsub('CO', "#{icons__contact} ")

    raw with_icon
  end

  def icons__activity
    raw '<i class="fa-duotone fa-solid fa-arrows-turn-to-dots fa-flip-vertical" ' \
          'style="--fa-primary-color: rgb(30, 48, 80); ' \
          '--fa-secondary-color: rgb(240, 118, 24); --fa-secondary-opacity: 1;"></i>'
  end

  def icons__action
    raw '<i class="fa-duotone fa-solid fa-list-check" ' \
          'style="--fa-primary-color: rgb(245, 130, 49); ' \
          '--fa-secondary-color: rgb(24, 126, 240); --fa-secondary-opacity: 1;"></i>'
  end

  def icons__contact
    raw '<i class="fa-duotone fa-solid fa-circle-user" ' \
      'style="--fa-primary-color: rgb(0, 0, 0); ' \
      '--fa-secondary-color: var(--color-emerald-600);"></i>'
  end

  def icons__command_centre
    raw '<i class="fa-light fa-globe"></i>'
  end

  # used for:
  #   titlebar of contactheroz
  #   referring to contactheroz from other slices
  def icons__contact_heroz
    raw '<i class="fa-duotone fa-solid fa-hand-holding-hand" ' \
          'style="--fa-primary-color: rgb(47, 127, 177); ' \
          '--fa-secondary-color: rgb(240, 232, 24); --fa-secondary-opacity: 1;"></i>'
  end

  def icons__legal_entity
    raw '<i class="fa-fw fa-sharp fa-light fa-scale-balanced"></i>'
  end

  def icons__circle_heroz
    raw '<i class="fa-kit-duotone fa-people-group-circle" ' \
          'style="--fa-primary-color: rgb(30, 48, 80); ' \
          '--fa-secondary-color: rgb(99, 230, 190); --fa-secondary-opacity: 1;"></i>'
  end

  def icons__solar_system
    raw '<i class="fa-kit-duotone fa-circle-solar-system" ' \
          'style="--fa-secondary-color: rgb(255, 234, 9); --fa-secondary-opacity: 1;"></i>'
  end

  def icons__address_book
    raw '<i class="fa-sharp fa-light fa-address-book"></i>'
  end
end
