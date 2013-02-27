class AddnewController < ApplicationController

  def index
    find_name = Contact.where(name: params['name'])
    if find_name.length > 0
      render :json => { answer: 'duplicate!' }
    else
      Contact.create(:name => params['name'], :last_date => Date.today.to_s, :position => params['position'], :red_val => 30)
      render :json => { answer: 'added' }
    end
  end

end