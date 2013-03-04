class SettingsController < ApplicationController

  def index
    input_length = params['name'].length
    red_value = Contact.find_by_id(params['id']).red_val
    render :json => {red_value: red_value, name: params['name'], length: input_length}
  end

end