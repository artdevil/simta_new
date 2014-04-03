class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @documents_ta = Document.ta
    @documents_proposal = Document.proposal
    @documents_miss = Document.miss
  end
  
  def new
    @document = Document.new
  end
  
  def create
    @document = Document.new(params[:document])
    @document.user = current_user
    if @document.save
      flash[:success] = "Document has been create"
      redirect_to documents_path
    else
      flash[:error] = "Document can't create"
      render :new
    end
  end
  
  def destroy
    @document = Document.find(params[:id])
    if @document.destroy
      flash[:success] = "Document has been rdelete"
      redirect_to documents_path
    end
  end
end
