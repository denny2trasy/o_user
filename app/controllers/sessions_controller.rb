class SessionsController < SessionServicesController
  ignore_login :only => %w{new create destroy}
  skip_before_filter :verify_authenticity_token, :only => [:show]

  def new
    flash[:notice] = params[:msg]    
  end

  # the method inherit from SessionServicesController
  # if you write the method by yourself, please inherit ApplicationController instead of
  # SessionServicesController
  #
  # def create
  # end

  def destroy
    reset_session   
    redirect_to params[:forward] || signin_url
  end
  
  def show
    reset_session   
    redirect_to params[:forward] || signin_url
  end
  
  
end

