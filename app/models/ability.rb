# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else

      can [ :index ], LegalEntity
      can [ :index ], Mission
      can [ :connector_preview, :update_connecting, :refresh_connection, :remove_connector,
           :update_connector, :slices ], User do |user__observing|
        user.id == user__observing.id
      end
      # LegalEntity permissions: responsible and contributor can view
      can [ :show ], LegalEntity do |legal_entity|
        legal_entity.entity_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

      can [ :update ], EntityUser do |entity_user|
        entity_user.legal_entity.entity_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

      # Mission permissions: responsible and contributor can view and update
      can [ :show, :update ], Mission do |mission|
        mission.mission_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

      # MissionUser permissions: responsible and contributor can add new users to mission
      can [ :new, :create ], MissionUser do |mission_user|
        mission_user.mission.mission_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

      # MissionUser permissions: only responsible can update user roles
      can [ :update ], MissionUser do |mission_user|
        mission_user.mission.mission_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

      # Transaction permissions: responsible and contributor can create
      can [ :new, :create, :show, :duplicate ], Transaction do |transaction|
        transaction.mission.mission_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

      # Transaction permissions: responsible and contributor can modify
      can [ :edit, :update, :destroy ], Transaction do |transaction|
        transaction.mission.mission_users.find_by(user: user, role: [ :responsible, :contributor ])
      end

    end
  end
end
