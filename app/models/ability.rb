class Ability
  include CanCan::Ability

  def initialize(user)
    if user.user_role_id == 1
      can :read, Topic
      can :create, TopicTag
      cannot :update, TopicTag
      can :show, TopicTag, :user_id == user.id
      can :manage, StudentsStatus, :user_id == user.id
      cannot :create, Proposal
      can :update, Proposal
      can :update_document, Proposal
      cannot :update_progress, Proposal
      cannot :update_progess, FinalProject
      can :create, TodoProposal
      cannot :finished, TodoProposal
      cannot :finished, Proposal
    elsif user.user_role_id == 2
      can :read, Topic
      can :manage, Topic, :user_id == user.id
      can :show, TopicTag, :advisor_id == user.id
      cannot :create, TopicTag
      can :update, TopicTag
      can :create, Proposal
      can :update, Proposal
      can :update_progress, Proposal
      can :update_progress, FinalProject
      can :new_report, FinalProject
      can :create_report, FinalProject
      can :create, TodoProposal
      can :finished, TodoProposal
      can :finished, Proposal
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
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
