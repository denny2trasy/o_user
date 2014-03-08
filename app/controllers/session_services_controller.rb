class SessionServicesController < ApplicationController
  ignore_login :all

  def create
    profile = Profile.authenticate(params[:login], params[:password])

    # method 1 : just check if user login other place
    # if check_user_login?(profile)
    #   I18n.locale = params[:locale] || "en"
    #   redirect_to referer_url_with_msg(I18n.t("session.login_other_place"))
    # else
      # puts "Before set current user = #{current_user}"
      # set_current_user(profile)
      # puts "After set current user = #{current_user}"
      # puts "Here time"
      # puts "Session[:expired_at] = #{session[:expires_at]} -- #{session[:expires_at].to_s}"
      # debugger
    #   redirect_to params.key?(:forward) ? URI.unescape(params[:forward]) : :back
    # end
    
    # method 2 : make sure in system there is just one login
    clear_other_session(profile)
    set_current_user(profile)
    redirect_to params.key?(:forward) ? URI.unescape(params[:forward]) : :back

  rescue Exception => e
    redirect_to referer_url_with_msg(e.message)
  end
  
  protected
  def check_user_login?(profile)
    ActiveRecord::SessionStore::Session.all.each do |s|
      # debugger
      data = s.data_was
      if data.keys.include?("current_user_id") and data.keys.include?("expires_at")
        if profile.id == data["current_user_id"] and data["expires_at"] > 0.minutes.from_now
          return true
          break 
        end
      end
    end
    return false
  end
  
  # clear this user other session in active record session
  def clear_other_session(profile)
    ActiveRecord::SessionStore::Session.all.each do |s|
      # debugger
      data = s.data_was
      if data.keys.include?("current_user_id") and data.keys.include?("expires_at")
        if profile.id == data["current_user_id"] and data["expires_at"] > 0.minutes.from_now
          s.destroy
        end
      end
    end
  end
  
end
