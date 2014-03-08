class Right < ActiveRecord::Base
  belongs_to :parent, :class_name => "Right"
  has_many :children, :class_name => "Right", :foreign_key => "parent_id", :dependent => :destroy, :order => "name"
  has_many :role_rights, :dependent => :destroy
  def roles; self.role_rights.all(:include => :role, :order=>"role_id").map(&:role); end
  named_scope :roots, :conditions=>"parent_id is null", :include => :children
  named_scope :recent_updated, lambda{{:conditions => ["updated_at >= ?", 5.days.ago]}}
  named_scope :eleutian_rights, :conditions => "parent_id is null and right_type = 'eleutian'"

  after_create :update_root
  def update_root
    unless self.parent.blank?
      self.root.update_attribute(:updated_at, Time.now)
    end
  end

  def self.reset(data)
    dt = DataTree.build(data)
    app = self.find(:first, :conditions=>["name=? and parent_id is null", dt.root.data])
    app.blank? ? Right.new.create_children_from_node(dt.root) : recur_reset(app, dt.root)
  end
  
  def self.reset_rails3(app_name, controllers)
        
    app = self.find_or_create_by_name_and_right_type(app_name, 'eleutian')
    controllers ||= []
    children = app.children.map(&:name)
    
    added = controllers - children
    removed = children - controllers
    added.each do |controller|
      app.children.create(:name => controller, :right_type => 'eleutian')
    end
    removed.each do |controller|
      app.children.find_by_name(controller).try(:destroy)
    end
  end

  def create_children_from_node(node)
    right = Right.create(:name => node.data, :parent_id => self.id)
    node.children.each{|child| right.create_children_from_node(child)}
  end

  def full_path
    ([(parent.blank? ? nil : parent.full_path), name]-[nil]).join("/")
  end

  def url(domain)
    parent.blank? ? "http://#{name}.#{domain.name}.com" : [parent.url(domain), name].join("/")
  end

  def root
    self.parent.blank? ? self : parent.root
  end

  def depth
    self.parent.blank? ? 0 : self.parent.depth + 1
  end

  def auto_set?
    true
  end

  def reset_roles(role_ids, in_recusive = false)
    return if role_ids.blank?
    if self.children.blank?
      self.role_rights.delete_all unless in_recusive
      self.add_roles(role_ids)
    else
      self.children.each{|child| child.reset_roles(role_ids, true)}
    end
  end

  def add_roles(role_ids)
    role_ids.each do |role_id|
      self.role_rights.create(:role_id => role_id) if self.role_rights.find_by_role_id(role_id).blank?
    end
  end

  private
  def self.recur_reset(right, node)
    deleted = []
    right.children.each{|child|
      n = node.children.select{|t| t.data == child.name}.first
      if n.blank? 
        deleted << child if child.auto_set?
      else
        recur_reset(child, node.children.delete(n))
      end
    }
    deleted.each{|r| r.destroy}
    node.children.each{|n| right.create_children_from_node(n)}
  end
end
