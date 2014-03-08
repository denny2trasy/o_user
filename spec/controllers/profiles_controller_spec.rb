require 'spec_helper'

describe ProfilesController do
  before do
    @profile = Factory(:profile)
    login_as @profile
  end

  describe "GET new" do
    it "render" do
      get :new

      response.should be_success
    end
  end

  describe "POST create" do
    it "redirect to forward when success" do
      forward = generate_example_url
      lambda {
        post :create, {:profile => {:login => 'new_user', :password => '123456', :mail => 'fred@eleutian.com'}, :forward => forward}
      }.should change{ Profile.count }.by(1)

      response.should redirect_to(forward)
    end

    it "redirect to new_profile_path when success and without forward" do
      lambda {
        post :create, {:profile => {:login => 'new_user', :password => '123456', :mail => 'fred@eleutian.com'}}
      }.should change{ Profile.count }.by(1)

      response.should redirect_to(signin_url)
    end

    it "set current_user when success" do
      post :create, {:profile => {:login => 'new_user', :password => '123456', :mail => 'fred@eleutian.com'}}

      controller.current_user_id.should == Profile.last.id
    end

    it "render new when fail" do
      lambda {
        post :create, {}
      }.should change{ Profile.count }.by(0)

      response.should render_template('new')
    end
  end

  describe "GET edit" do
    it "render" do
      get :edit, :id => 0

      response.should be_success
    end
  end

  describe "PUT update" do
    it "redirect to edit when success" do
      put :update, {:id => 0, :profile => {:mobile => '13702348574'}}

      response.should redirect_to(profile_path)
    end

    it "can't update anyting" do
      login = @profile.login
      put :update, {:id => 0, :profile => {:login => 'new login'}}

      @profile.login.should == login
    end

    it "render edit when fail because email has incorrect formation" do
      put :update, {:id => 0, :profile => {:mail => 'abc'}}

      response.should render_template('edit')
    end
  end

end
