ActiveAdmin.register Proposal do
  index do
    column :student do |f|
      f.user.username
    end
    column :advisor_1 do |f|
      f.advisor_1.username
    end
    column :advisor_2 do |f|
      f.advisor_2.present? ? f.advisor_2.username : f.advisor_2_name
    end
    column :progress do |f|
      "#{f.progress}%"
    end
    column :status do |f|
      status_tag(f.complete? ?  'completed' : 'in progress')
    end
    default_actions
  end
  
  config.batch_actions = false
  scope :all
  scope :in_progress
  scope :completed
  scope :archieved
end
