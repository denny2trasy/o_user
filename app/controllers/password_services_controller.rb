class PasswordServicesController < ApplicationController

  def update
    profile = Profile.authenticate(params[:login], params[:original_password])
    if profile.update_attributes :password => params[:password], :password_confirmation => params[:password_confirmation]
      redirect_to referer_url_with_msg(I18n.t(:update_success))
    else
      redirect_to referer_url_with_msg(profile.errors['password'])
    end
  rescue
    redirect_to referer_url_with_msg(I18n.t('passwords.original_password_error'))
  end
end
