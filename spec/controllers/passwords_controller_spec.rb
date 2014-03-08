require 'spec_helper'

describe PasswordsController do
  before do
    @password = '123456'
    @profile = Factory(:profile, :password => @password)
    login_as @profile
  end

  describe "GET edit" do
    it "render" do
      get :edit

      response.should be_success
    end
  end

  describe "PUT update" do
    it "when original password is invalid" do
      put :update, :original_password => 'invalid password', :id => 0

      response.should render_template('edit')
    end

    it "when new password is invalid" do
      put :update, {:id => 0, :original_password => @password, :password => ''}

      response.should render_template('edit')
    end

    it "when confirmation password is invalid" do
      put :update, {:id => 0, :original_password => @password, :password => 'new_password', :password_confirmation => 'jj'}

      response.should render_template('edit')
    end

    it "when success" do
      new_password = 'abcdef'
      put :update, {:id => 0, :original_password => @password, :password => new_password, :password_confirmation => new_password}

      response.should redirect_to(password_url)
    end
  end

end
