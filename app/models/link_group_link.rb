class LinkGroupLink < ActiveRecord::Base
  belongs_to :link
  belongs_to :link_group
  acts_as_list :scope => :link_group
 
end
