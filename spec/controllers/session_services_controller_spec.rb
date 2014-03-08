require 'spec_helper'

describe SessionServicesController do
  before do
    @example_url = "http://example.com/#{rand(10000)}"
    @password = '123456'
    @profile = Factory(:profile, :password => @password)
  end

  describe "POST create" do
    before do
      @referer_url = "http://referer.example.com"
      request.env['HTTP_REFERER'] = @referer_url
    end

    describe "when success" do
      it "redirect to forward" do
        post :create, {:login => @profile.login, :password => @password, :forward => @example_url}

        response.should redirect_to(@example_url)
      end

      it "redirect to back" do
        post :create, {:login => @profile.login, :password => @password}

        response.should redirect_to(@referer_url)
      end

      it "set current_user" do
        controller.current_user.should be_nil

        post :create, {:login => @profile.login, :password => @password}

        controller.current_user.id.should == @profile.id
      end
    end

    describe "when fail" do
      it "when referer without argument" do
        post :create, {:login => @profile.login, :password => 'invalid password'}

        response.should redirect_to(URI.parse(@referer_url).add_query(:msg => I18n.t(:invalid_user)).to_s)
      end

      it "when referer with argument" do
        request.env['HTTP_REFERER'] = "#{@referer_url}?name=abc"

        post :create, {:login => @profile.login, :password => 'invalid password'}

        response.should redirect_to(URI.parse(@referer_url).add_query(:name => 'abc', :msg => I18n.t(:invalid_user)).to_s)
      end
    end
  end
end
