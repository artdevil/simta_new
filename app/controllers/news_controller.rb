class NewsController < InheritedResources::Base
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :set_user, :only => :create
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "News", :news_index_path
  before_filter :set_last_breadcrumbs
  
  protected
    def set_user
      @news.user = current_user
    end
    
    def set_last_breadcrumbs
      case action_name
      when 'new' || 'create'
        add_breadcrumb "New"
      when 'edit' || 'update'
        add_breadcrumb "Edit"
      when 'show'
        add_breadcrumb "Show"
      end
    end
    
    def collection
      @news = News.page(params[:page]).per(5)
    end
end
