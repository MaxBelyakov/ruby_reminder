class UpdateController < ApplicationController

  def index
    Contact.find_by_id(params['id']).update_attributes(:last_date => Date.today.to_s)
    render :json => { }
  end

end