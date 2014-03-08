require 'spec_helper'

describe UserServicesController do

  describe "create action" do
    it "should redirect to request with message no enough params" do
      post  :create,  :profile => {:login => "denny",:forward => "/"}
      response.should be_redirect   
      flash[:message].should == "Params is not valid!"   
    end
    it "should redirect to studycenter after login or register" do
      post  :create,  :profile => {:login => "denny",:password => "lgd123456",:email => "abc@eleutian.com", :forward => "/",:partner => "tw"}
      response.should be_redirect
      controller.current_user.login.should == "tw_denny"
    end

  end

end
