class DocumentsController < ApplicationController
  def index
    @documents_ta = Document.ta
    @documents_proposal = Document.proposal
    @documents_miss = Document.miss
  end

  def show
  end
end
