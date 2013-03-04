class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter do
    # Gon variables
    gon.addnew_path = addnew_path
    gon.delete_path = delete_path
    gon.contact_path = contact_path
    gon.update_path = update_path
    gon.settings_path = settings_path
    gon.update_color_path = update_color_path
  end
end
