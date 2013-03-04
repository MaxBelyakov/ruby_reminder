class UpdateColorController < ApplicationController

  def index
    Contact.find_by_id(params['id']).update_attributes(:red_val => params['red'])

    render :json => { }
  end

end