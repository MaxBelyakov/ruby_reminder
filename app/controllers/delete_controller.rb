class DeleteController < ApplicationController

  def index
    Contact.find(params['id']).delete
    render :json => { }
  end

end