SimtaNew::Application.routes.draw do
  devise_for :users
  authenticated :user do
      root :to => "dashboards#index"
  end
  
  devise_scope :user do
    get "/", :to => "devise/sessions#new"
  end
  
  root :to => "devise/sessions#new"
  
  mount Ckeditor::Engine => '/ckeditor'
  
  resources :dashboards
  resources :user_profiles do
    collection do
      get 'search'
      get 'search_only_advisor'
      get 'search_only_student'
    end
  end
  resources :messages do
    member do
      get 'reply'
    end
  end
  resources :notifications do
    collection do
      get 'old'
    end
  end
  resources :topics
  resources :topic_tags
  
  resources :proposals do
    member do
      put 'update_progress'
      post 'update_document'
      put 'finished'
    end
  end
  
  resources :final_projects do
    member do
      put 'update_progress'
      get 'new_report'
      post 'create_report'
      put 'finished'
      get 'show_history'
      get 'activities'
      put 'update_document'
    end
  end
  resources :todo_proposals do
    collection do
      get 'issue/:user_id', :action => "issue"
      get 'issue/:user_id/new', :action => "new_todo"
      post 'issue/:user_id', :action => "create_todo"
      get ':user_id/open', :action => "open"
      get ':user_id/close', :action => "close"
      get 'issue/:user_id/:id', :action => "issue_todo"
      # post 'issue/:user_id/:id', :action => "issue_todo_create"
      put 'issue/:user_id/:id', :action => "finished"
      get 'open'
      get 'close'
    end
    
    member do
      get 'issue/:user_id/edit', :action => "edit_todo"
      put 'issue/:user_id/update', :action => "update_todo"
    end
  end
  
  resources :todo_final_projects do
    collection do
      get 'issue/:user_id', :action => "issue"
      get 'issue/:user_id/new', :action => "new_todo"
      post 'issue/:user_id', :action => "create_todo"
      get 'issue/:user_id/:id', :action => "issue_todo"
      get ':user_id/open', :action => "open"
      get ':user_id/close', :action => "close"
      put 'issue/:user_id/:id', :action => "finished"
    end
    
    member do
      get 'issue/:user_id/edit', :action => "edit_todo"
      put 'issue/:user_id/update', :action => "update_todo"
    end
  end
  
  resources :comments
  resources :news
  resources :documents
  resources :archives
  resources :examiners do
    member do
      get :revision_status
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
