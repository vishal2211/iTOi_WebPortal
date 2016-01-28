class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, Recording do |recording|

      # Default access
      access = false

      # At minimum the recording must be active
      if recording.active == true

        if user.is_admin?
          access = true

        elsif recording.created_by == user.id
          # If the user is the creator of the recording
          access = true

        elsif user.user_ids_can_control.include? recording.created_by
          # If recording.created_by is a user, which the current user has account admin authorization over.
          # CAUTION: since the recordings have absolutely no "company" traceability, there is a possibility
          # for a user to belong to two account managers, in which the recordings will be displayed to both
          # account managers.
          access = true
        end

      end

      if recording.new_record?
        access = true
      end

      access
    end

    can :manage, MediaItem do |media_item|
      user.company && (user.company.id == media_item.company_id)
    end

    can :manage, Plan if user.is_admin?

    can :manage, Company do |company|
      user.is_admin? || (CompanyUser.where(user_id: user.id, company_id: company.id).length > 0)
    end

  end
end
