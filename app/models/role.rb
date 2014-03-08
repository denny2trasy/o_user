class Role < ActiveRecord::Base  
  acts_as_list
  
   has_many :profile_roles, :dependent => :delete_all
   has_many :profiles, :through => :profile_roles

   has_many :role_rights, :dependent => :delete_all
   has_many :rights, :through => :role_rights
   has_many :link_groups, :dependent => :destroy

   has_many :role_portal_links
   has_many :portal_links, :through => :role_portal_links

   def links
     links = self.link_groups.map{|group| group.links}
     links.blank? ? links : links.sum
   end
   
   def self.roots
     self.find(:all, :conditions=>['parent_id is null'])
   end
   
   def children
     Role.find_all_by_parent_id self.id
   end

   def all_link_groups
     self.link_groups + (self.parent.try(:all_link_groups) || [])
   end

   def all_rights
     rights + (parent.try(:all_rights)||[])
   end

   def self.find_by_path(path)
     c = Role.roots
     names = path.split(".")
     names.each_with_index do |name, index|
       role = c.detect{|role| role.name_db == name}
       return role if role.blank? or index == names.size-1
       c = role.children
     end
   end

   def self.root_id
     315
   end

   def self.admin_id
     14
   end

   def to_xml(options={})
     class << self
       def name; name_db; end
     end
     super(options.merge!({:only => [:id, :name], :dasherize => false}))
   end
  
end
