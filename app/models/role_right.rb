class RoleRight < ActiveRecord::Base
  belongs_to :role
  belongs_to :right

  def before_create
    self.path = self.right.full_path
  end
end
