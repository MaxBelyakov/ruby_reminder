class AddnewController < ApplicationController

  def index
    find_name = Contact.where(name: params['name'])
    if find_name.length > 0
      render :json => { answer: 'duplicate!' }
    else
      # Add to Model here
      render :json => { answer: 'added' }
    end
  end

end