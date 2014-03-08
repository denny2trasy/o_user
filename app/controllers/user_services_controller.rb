class UserServicesController < ApplicationController
  ignore_login
  
  # it used by partner for user register and login
  # params => login password email partner forward
  def create
    if Profile.check_partner_params(params[:profile])
      begin
        profile = Profile.register_or_login(params[:profile])
        set_current_user(profile)
        redirect_to studycenter_path
      rescue  Exception => e
        flash[:message] = "Server error, please contact us!"
        redirect_to params[:profile][:forward]
      end
    else
      flash[:message] = "Params is not valid!"
      redirect_to params[:profile][:forward]
    end
  end
  
  private
  
  def studycenter_path
    EcoApps.current.config["studycenter_path"]
  end
end
