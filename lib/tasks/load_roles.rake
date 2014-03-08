desc 'Load roles from system'
task :load_roles => :environment do
  roles = SysRole.find_all_by_list_type('Role')
  for role in roles
    if role.parent_id.blank?
      role_parent_id = 'null'
    else
    role_parent_id = role.parent_id
    end

    if Role.find_by_id(role.id).blank?
      sql = "insert into v2_user_production.roles (id, name, parent_id, position, name_en, name_zh, has_children)
      values ( #{role.id}, '#{role.name}', #{role_parent_id}, #{role.position}, '#{role.name_en}', '#{role.name_zh}', #{role.has_children})"
      ActiveRecord::Base.connection.execute(sql)
      puts 'insert role ' + role.id.to_s
    end
  end

end


# rake register user controllers

desc 'add user controllers'
task :reset_user_controllers => :environment do
  puts get_controllers.inspect
  RightService.post(:reset_rights, :app => EcoApps.current.name, :controllers => get_controllers)
end

# add column right_type into rights table
desc 'add right table column'
task :add_rights_table_column => :environment do
  AddRightTypeToRights.up
end


class AddRightTypeToRights < ActiveRecord::Migration
  def self.up
    add_column  :rights,  :right_type, :string
  end

  def self.down
    remove_column :rights,  :right_type
  end
end

private
    def get_controllers
      Dir["#{Rails.root}/app/controllers/**/*.rb"].each {|file| require file }
      controllers_path(ApplicationController.subclasses) << 'session_services'
    end
    
    def controllers_path(controllers)
      controllers.map{|c| c.subclasses.blank? ? c.controller_path : controllers_path(c.subclasses)}.flatten
    end



