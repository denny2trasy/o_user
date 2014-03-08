require 'spec_helper'

describe ProfileServicesController do
  before do
    @profile = Factory(:profile)
    @example_url = generate_example_url
  end

  describe "POST create" do
    it "redirect forward when success" do
      lambda {
        post :create, {:profile => {:login => 'new_user', :password => '123456', :mail => 'fred@eleutian.com'}, :forward => @example_url}
      }.should change{ Profile.count }.by(1)
      
      response.should redirect_to(@example_url)
    end

    it "redirect back with msg when fail" do
      request.env['HTTP_REFERER'] = @example_url
      lambda {
        post :create, {}
      }.should change{ Profile.count }.by(0)
      
      response.should redirect_to(URI.parse(@example_url).add_query(:msg => I18n.t(:register_fail)).to_s)
    end
  end

  describe "PUT update" do
    before do
      login_as @profile
    end

    it "redirect forward when success" do
      put :update, {:id => 0, :profile => {:given_name => 'ga'}, :forward => @example_url}

      response.should redirect_to(@example_url)
    end

    it "can't update anyting" do
      login = @profile.login
      put :update, {:id => 0, :profile => {:login => 'new login'}, :forward => @example_url}

      @profile.login.should == login
    end

    it "redirect back with msg when fail" do
      request.env['HTTP_REFERER'] = @example_url
      lambda {
        post :update, {:id => 0, :forward => @example_url, :profile => {:mail => 'invalid mail'}}
      }.should change{ Profile.count }.by(0)
      
      response.should redirect_to(URI.parse(@example_url).add_query(:msg => I18n.t(:update_fail)).to_s)
    end
  end

end
