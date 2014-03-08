require 'spec_helper'

describe SessionsController do
  before do
    @example_url = generate_example_url
  end

  describe "new action" do
    it  "should render new page" do
      get :new
      response.should render_template("new")
    end
  end
  
  describe "DELETE destroy" do
    before do
      @profile = Factory(:profile)
      login_as @profile
    end

    it "redirect to forward" do
      delete :destroy, :forward => @example_url

      response.should redirect_to(@example_url)
    end

    it "redirect signin page" do
      delete :destroy

      response.should redirect_to(signin_url)
    end
  end
  
end
