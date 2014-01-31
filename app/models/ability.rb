class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :destroy, :edit, :update, :to => :ud
    alias_action :edit, :update, :to => :updated
    if user
      #global
      can :read, Topic
      can :manage, Message
      
      if user.is_student?
        # TOPIC TAG
        can :create, TopicTag
        can [:updated, :read], TopicTag do |topic_tag|
          topic_tag.try(:user) == user
        end
        
        # PROPOSAL
        can [:show, :update_document], Proposal do |proposal|
          proposal.try(:user) == user
        end
        
        #TODO PROPOSAL
        can [:open,:close, :read, :create, :new], TodoProposal
        can [:update, :edit], TodoProposal do |todo_proposal|
          todo_proposal.try(:user) == user
        end
        
        # FINAL PROJECT
        can [:show, :show_history, :activities, :update_document], FinalProject do |final_project|
          final_project.user == user
        end
        
        #TODO FINAL PROJECT
        can [:open, :close, :index, :create, :read, :new], TodoFinalProject
        can [:update, :edit], TodoFinalProject do |todo_final_project|
          todo_final_project.try(:user) == user
        end
        
        # COMMENT
        can :create, Comment
        can :update, Comment do |comment|
          comment.try(:user) == user
        end
        
      elsif user.is_advisor?
        # TOPIC
        can :create, Topic
        can :ud, Topic do |topic|
          topic.try(:user) == user
        end
        
        # TOPIC TAG
        can [:read, :update], TopicTag do |topic_tag|
          topic_tag.try(:advisor_topic_tag) == user
        end
        
        # PROPOSAL
        can :create, Proposal
        can [:show, :update, :update_document, :update_progress, :finished, :destroy], Proposal do |proposal|
          proposal.try(:advisor_1) == user
        end
        
        # TODO PROPOSAL
        can [:issue, :new_todo, :create_todo, :issue_todo, :open, :close, :finished, :check_user_advisor], TodoProposal
        can [:edit_todo, :update_todo], TodoProposal do |todo_proposal|
          todo_proposal.user = user
        end
        can [:access_todo_proposal], Proposal do |proposal|
          proposal.advisor_1 == user || proposal.advisor_2 == user
        end
        
        # FINAL PROJECT
        # , :edit, :update
        can [:update_progress, :finished], FinalProject do |final_project|
          final_project.advisor_1 == user
        end
        
        can [:new_report, :create_report, :show, :show_history, :activities], FinalProject do |final_project|
          final_project.user == user || final_project.advisor_1 == user || final_project.advisor_2 == user
        end
        
        # TODO FINAL PROJECT
        # :issue, :issue_todo, :new_todo, :create_todo, :edit_todo, :update_todo, :finished
        can [:open, :close, :issue, :issue_todo, :new_todo, :create_todo, :finished], TodoFinalProject
        can [:edit_todo, :update_todo], TodoFinalProject do |todo_final_project|
          todo_final_project.user == user
        end
        can [:access_todo_final_project], FinalProject do |final_project|
          final_project.advisor_1 == user || final_project.advisor_2 == user
        end
        
        # COMMENT
        can :create, Comment
        can :update, Comment do |comment|
          comment.try(:user) == user
        end
        
        # EXAMINER
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
  end
end
