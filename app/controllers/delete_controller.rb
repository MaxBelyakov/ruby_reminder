class DeleteController < ApplicationController

  def index
    Contact.find_by_id(params['id']).try(:delete)
    render :json => { }
  end

end