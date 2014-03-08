class ProfileServicesController < ApplicationController
  ignore_login
  before_filter :set_locale
  
  def set_locale
    I18n.locale = "en"
  end
  def create
    @profile = Profile.new(params[:profile])
    @profile.user_type = 'student'

    if @profile.save
   
      set_current_user(@profile)
      redirect_to params[:forward] || '/'
    else
      error_str = ''
      @profile.errors.each do |attr,message|
        error_str += "<p>"+I18n.t(attr.to_s)+" "+message.to_s+"</p>"
      end
      redirect_to referer_url_with_msg(error_str)
    end
  end

  def update
    @profile = Profile.find(current_user.id)
    approved_fields = [:mobile, :mail, :given_name, :qq, :msn, :locale, :time_zone]
    profile_attrs = Profile.extract_keys_to_prevent_vandals(params[:profile], approved_fields)

    if @profile.update_attributes(profile_attrs)
      redirect_to params[:forward]
    else
      redirect_to referer_url_with_msg(I18n.t(:update_fail))
    end
  end
end
