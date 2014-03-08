require 'spec_helper'

describe Profile do

  describe ".extract_keys_to_prevent_vandals" do
    it "extract 3 keys" do
      h = Profile.extract_keys_to_prevent_vandals({:a => 1, :b => 2}, [:a, :c])
      h.keys.should == [:a]
      h[:a].should == 1
    end
  end
  
  describe ".check_partner_params(params)" do
    it "should be true when params include login/password/email/partner/forward" do
      h = {:login => "denny","password" => "lgd", :email => "abc@eleutian.com", :partner => "tw", :forward => "/tw"}
      Profile.check_partner_params(h).should be_true
    end
    it "should be false when params[partner] == '' " do
      h = {:login => "denny",:password => "lgd", :email => "abc@eleutian.com", :partner => "", :forward => "/tw"}
      Profile.check_partner_params(h).should be_false     
    end
  end
  
  describe "register_or_login(params)" do
    it "should register new student when partner_login not exist in database" do
      h = {:login => "denny",:password => "lgd123456", :email => "abc@eleutian.com", :partner => "tw", :forward => "/tw"}
      c = Profile.count
      Profile.register_or_login(h)
      Profile.count.should == (c + 1)
    end
    it "should login by student when partner_login exist in database" do
      profile = Factory(:profile,:login => "tw_denny",:password => "lgd123456")
      h = {:login => "denny",:password => "lgd123456", :email => "abc@eleutian.com", :partner => "tw", :forward => "/tw"}
      c = Profile.count
      Profile.register_or_login(h).should == profile
      Profile.count.should == c
    end
  end
end
