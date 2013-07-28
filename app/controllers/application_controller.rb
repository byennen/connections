class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  #def after_sign_in_path_for(resource)
  #  edit_user_path(current_user)
  #end

  #def after_sign_up_path_for(resource)
  #
  #end

  #password for staging
  if (ENV["RAILS_ENV"] == "staging")
    before_filter :verifies_staging_user
  end

  def verifies_staging_user
    unless cookies[:ccahoots_connect]
      authenticate_or_request_with_http_basic do |username, password|
        username == "cahoots" && password == "cahoots2013"
        cookies[:cahoots_connect] = {:value => "staging", :expires => 5.days.from_now.utc, :domain => :all}
      end
    end
  end
end
