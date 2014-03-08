class PartnerProfile < ActiveRecord::Base
  belongs_to :profile, :foreign_key => :user_id
  delegate :login, :given_name, :to => :profile, :allow_nil => true
end