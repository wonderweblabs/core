module Shoppe
  class ApplicationController < ActionController::Base

    before_filter :login_required

    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      redirect_to request.referer || root_path, :alert => e.message
    end

    rescue_from Shoppe::Error do |e|
      @exception = e
      render :layout => 'shoppe/sub', :template => 'shoppe/shared/error'
    end

    private

    def login_required
      unless logged_in?
        redirect_to login_path
      end
    end

    def logged_in?
      current_user.is_a?(Shoppe::User)
    end

    def current_user
      @current_user ||= login_from_session || login_with_demo_mdoe || :false
    end

    def login_from_session
      if session[:shoppe_user_id]
        @user = Shoppe::User.find_by_id(session[:shoppe_user_id])
      end
    end

    def login_with_demo_mdoe
      if Shoppe.settings.demo_mode?
        @user = Shoppe::User.first
      end
    end

    helper_method :current_user, :logged_in?

  end
end
