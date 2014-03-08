class LinkGroup < ActiveRecord::Base
  # globalize :name
  has_many :link_group_links, :order => :position, :dependent => :destroy
  has_many :links, :through => :link_group_links
  belongs_to :role
end
