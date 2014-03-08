class ProfilesController < ApplicationController
  ignore_login :only => %w{new create}

  def index
    unless current_user
      redirect_to '/sessions/new'
    end
    
    if (type = params[:q].try("[]",:client_type)).present?
      redirect_to :action => :client, :type => type
    else
      @profiles = Profile.combo_search(params,:order => "id desc")
    end
  end


  def new
    @profile = Profile.new
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def create
    @profile = Profile.new(params[:profile])
    @profile.user_type = 'student' if @profile.user_type.blank?

    if @profile.save
      
      #set_current_user(@profile)
      redirect_to params[:forward] || profiles_url
    else
      render 'new'
    end
  end

  def update
    @profile = Profile.find(params[:id])
    # profile_attr = params[:profile].delete('')
    @profile.attributes = params[:profile]
    # @profile.attributes = profile_attr
    if @profile.save
      render :text => params.inspect
    else
      render :text => 'error'
    end
  end

  def update_role
    @profile = Profile.where params[:id].to_i
    user_role = ProfileRole.find_by_role_id_and_profile_id(params[:role_id].to_i, params[:id].to_i)
    if params[:create] and user_role.blank?
      ProfileRole.create!(:role_id => params[:role_id], :profile_id => params[:id])
    elsif user_role
      user_role.destroy      
    end
    render :text => 'ok'
  end
  
end
