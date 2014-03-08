class RightServicesController < ApplicationController
  ignore_login :all
  
  def reset_rights
    if params[:app].blank?
      Right.reset(params[:data]) 
    else
      Right.reset_rails3(params[:app], params[:controllers])
    end
    
    render :xml => "<info>Reset successfully!</info>", :status => :ok    
  end

end