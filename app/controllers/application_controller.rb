class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter do
    # Gon variables
    gon.addnew_path = addnew_path
    gon.delete_path = delete_path
  end
end
