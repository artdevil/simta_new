class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :destroy, :edit, :to => :ud
    user ||= User.new # guest user (not logged in)
    if user
      can :read, Topic
      can :manage, Message
      if user.is_student?
        can :manage, TopicTag
        can :edit, TopicTag do |topic_tag|
          topic_tag.try(:user) == user
        end
        can [:update, :update_document, :check_user], Proposal
        can [:open,:close, :check_user_advisor, :read, :create], TodoProposal
        can :update, TodoProposal do |todo_proposal|
          todo_proposal.try(:user) == user
        end
        can [:open,:close, :check_user_advisor, :read, :create], TodoFinalProject
        can :update, TodoFinalProject do |todo_final_project|
          todo_final_project.try(:user) == user
        end
        can :update, Comment do |comment|
          comment.try(:user) == user
        end
        can :create, Comment
        can [:check_user_for_report, :show], FinalProject
      elsif user.is_advisor?
        can :create, Topic
        can :ud, Topic do |topic|
          topic.try(:user) == user
        end
        can :read, TopicTag
        can :update, TopicTag
        can :manage, [Proposal, TodoProposal, FinalProject, TodoFinalProject]
        can :create, Comment
        can :update, Comment do |comment|
          comment.try(:user) == user
        end
        
        can :read, Examiner do |examiner|
          examiner.try(:examiner_1) == user || examiner.try(:examiner_2) == user || examiner.try(:examiner_3) == user || examiner.final_project.try(:advisor_1) == user || examiner.final_project.try(:advisor_2) == user
        end
        
        can :update, Examiner do |examiner|
          examiner.try(:examiner_2) == user
        end
        
        can :revision_status, Examiner do |examiner|
          examiner.try(:examiner_2) == user
        end
      end
    end
    # if user.is_student?
#       can :read, Topic
#       can :create, TopicTag
#       cannot :update, TopicTag
#       can :show, TopicTag, :user_id == user.id
#       can :manage, StudentsStatus, :user_id == user.id
#       cannot :create, Proposal
#       can :update, Proposal
#       can :update_document, Proposal
#       cannot :update_progress, Proposal
#       cannot :update_progess, FinalProject
#       can :create, TodoProposal
#       cannot :finished, TodoProposal
#       cannot :finished, Proposal
#     elsif user.is_advisor?
#       can :read, Topic
#       can :manage, Topic do |topic|
#         topic.try(:user) == user
#       end
#       can :show, TopicTag, :advisor_id == user.id
#       cannot :create, TopicTag
#       can :update, TopicTag
#       can :create, Proposal
#       can :update, Proposal
#       can :update_progress, Proposal
#       can :update_progress, FinalProject
#       can :new_report, FinalProject
#       can :create_report, FinalProject
#       can :create, TodoProposal
#       can :finished, TodoProposal
#       can :finished, Proposal
#     end
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
