class PartnerSessionsController < SessionServicesController
  #protect_action :authenticate
  ignore_login :all
  skip_before_filter :verify_authenticity_token
  
  def create
    if PartnerService.authenticate(params[:CoursePackageID],params[:UserID],params[:PartnerName],params[:Key])
      begin
      if PartnerProfile.find_by_partner_uid(params[:UserID]).blank?
        PartnerProfile.transaction do 
          Profile.transaction do
            
            @partner_profile = PartnerProfile.create!(:partner_uid => params[:UserID],:partner_name => params[:PartnerName])
            @user = Profile.create!({:remote_ip=>request.remote_ip}.merge(Profile.student_default).merge(partner_attrs))
            @partner_profile.update_attributes(:user_id => @user.id)
          end
        end
        render :text => "success" #success
      else
        render :text => "userid_been_used" #This user ID has been used
      end
    rescue Exception =>e
      render :text=> e.message
    end
    else
      render :text => "authenticate_fail" #Authenticate fail
    end
  end
  
  def login
    if PartnerService.authenticate(params[:CoursePackageID],params[:UserID],params[:PartnerName],params[:Key])
      if @partner_profile = PartnerProfile.find_by_partner_uid(params[:UserID])
        @user = @partner_profile.profile
        if @user
          set_current_user(@user)
          redirect_to params[:forward] || url_of(:el_studycenter, :home)
        else
          render :text => "fail" 
        end
      else
        render :text=>"User_not_exist"
      end
    else
      render :text=>"authenticate_fail"
    end
  end
  
  
  # for CDEL
  def authenticate
    if PartnerService.authenticate(params[:course_package],params[:userID],params[:partner_name],params[:key])
      begin
        if (@partner_profile = PartnerProfile.find_by_partner_uid(params[:userID])) and @partner_profile.profile
          @user = @partner_profile.profile
        else
          if @partner_profile.blank?
            @partner_profile = PartnerProfile.create!(:partner_uid => params[:userID],
              :partner_name => params[:partner_name],
              :lesson_tag => "webex")
          end
          @user = Profile.create!({:remote_ip=>request.remote_ip}.merge(Profile.student_default).merge(partner_attrs))
          @partner_profile.update_attributes(:user_id => @user.id)

        end

        if @user
          set_current_user(@user)
          redirect_to(target_place)
        else
          redirect_to "?error_msg=remote-error!"
        end
      rescue Exception => e
        redirect_to "?error_msg=remote-error-#{e.message}!"
      end
    else
      redirect_to "?error_msg=non-authenticated!"
    end
  end
  
  private
  def target_place
    if not params[:target].blank?
      return URI.decode(params[:target])
    else
        return url_of(:el_studycenter, :partners) + "?course_package=#{params[:course_package]}"
      
    end
  end
  
  def partner_attrs
    @pw = generate_password(6)
    {
      :password => @pw,
      :password_confirmation => @pw,
      :login => ("PRT_"+@partner_profile.partner_uid[0,8] + "_" + generate_password(1)),
      :from_partner => params[:PartnerName],
      :mail => params[:Email]
    }
  end
end
