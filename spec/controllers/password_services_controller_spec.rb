require 'spec_helper'

describe PasswordServicesController do
  before do
    @password = 'abcdef'
    @profile = Factory(:profile, :password => @password)

    request.env['HTTP_REFERER'] = generate_example_url
  end

  describe "PUT update" do
    it "with invalid login/password" do
      put :update, {:id => 0,:login => @profile.login, :original_password => 'invalid password'}

      response.should redirect_to(controller.send(:referer_url_with_msg, I18n.t('passwords.original_password_error')))
    end

    it "with invalid new password" do
      put :update, {:id => 0,:login => @profile.login, :original_password => @password, :password => ''}

      @profile.password = '' and @profile.valid?
      response.should redirect_to(controller.send(:referer_url_with_msg, @profile.errors['password']))
    end

    it "with un-confirmation password" do
      put :update, {:id => 0, :login => @profile.login, :original_password => @password, :password => 'haha', :password_confirmation => 'hehe'}

      @profile.attributes = {:password => 'haha', :password_confirmation => 'hehe'} and @profile.valid?
      response.should redirect_to(controller.send(:referer_url_with_msg, @profile.errors['password']))
    end

    it "success" do
      new_pwd = 'abcdfjeyfj'
      put :update, {:id => 0, :login => @profile.login, :original_password => @password, :password => new_pwd, :password_confirmation => new_pwd}

      response.should redirect_to(controller.send(:referer_url_with_msg, I18n.t(:update_success)))
    end

  end
end
