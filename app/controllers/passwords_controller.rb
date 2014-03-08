class PasswordsController < ApplicationController
  ignore_login :forgot
  layout :false ,:only => %w{forgot reset}

  def edit
    @profile = Profile.find(current_user.id)
  end

  def update
    @profile = Profile.find(current_user.id)

    if not @profile.password_correct?(params[:original_password])
      flash[:notice] = I18n.t('passwords.original_password_error')
      render 'edit'
    elsif not @profile.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
      flash[:notice] = @profile.errors[:password]
      render 'edit'
    else
      flash[:notice] = I18n.t(:update_success)
      redirect_to password_url
    end
  end
  
  def forgot
    @profile = Profile.new
    #render :layout => false
  end 
  
  def reset
    @user = Profile.find_by_login(params[:login])
    @redirect_url = params[:forward]
    if @user.nil? ? false :  @user.mail == params[:mail]
      @password = generate_password(3)
      if @user.update_attributes(:password => @password)
        UserMailer.reset_password(@user, @password).deliver
      end
    else
      redirect_to referer_url_with_msg(t(:login_or_email_error))
    end
  end
end
