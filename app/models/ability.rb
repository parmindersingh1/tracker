class Ability
  include CanCan::Ability
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    if user.role == "superuser"
      can :manage, :all
      can [:users,:edit_role,:update_role], :admin_panel
    elsif user.role == "admin"
      can [:read, :create, :update], [Device, Route, Stop, Vehicle]
      can [:user_routes], [Route]
      can [:user_vehicles],[Vehicle] 
      can [:users], :admin_panel
    elsif user.role == "user"
      can :read, :all
      can [:user_routes], [Route]
      can [:user_vehicles],[Vehicle] 
    else
      can :read, :all
    end

  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
