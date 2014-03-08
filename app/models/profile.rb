class Profile < ActiveRecord::Base
  has_many :profile_roles, :dependent => :destroy
  has_many :roles, :through => :profile_roles

  validates_presence_of :login, :on => :create
  validates_length_of :login, :in => 6..16, :on => :create
  validates_presence_of :mail, :on => :create
  validates_presence_of :password, :on => :create
  validates_length_of :password, :in => 6..16, :on => :create

  validates_uniqueness_of :login
  validates_uniqueness_of :mail
  validates_format_of :mail, :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  validates_confirmation_of :password
  validates_format_of :password, :with => /^[a-zA-Z_0-9]+$/, :unless => :password_nil?

  after_create :set_user_role
  
  def set_user_role
    r = Role.find_by_name self.user_type
    ProfileRole.create!(:role_id => r.id, :profile_id => self.id)
  end
  
  def password_nil?
    self.password.nil?
  end

  attr_accessor :password

  def password=(pwd)
    @password = pwd
    self.salt = ShaHelper.salt
    self.encrypted_password = Profile.encrypt_password(pwd, self.salt) if pwd.present?
  end

  def password_correct?(pwd)
    [Profile.encrypt_password(pwd, self.salt),ShaHelper.encrypt_util(pwd)].include?(self.encrypted_password)
  end
  
  def self.student_default
    {:user_type => "student", :time_zone=>"Beijing", :locale=>"zh"}
  end

  class << self
    PasswordEncryptKey = "7d6ad2f468269ac8958413446ea4094b1de56e26267718174747cd90348bdd5f6d4e1b3b6d2d0da6bac463a6a9ca716896ebf1190194982645eaae67d98f3eca"
    def encrypt_password(plain_password, salt)
      ShaHelper.encrypt(PasswordEncryptKey, salt.to_s + plain_password.to_s)
    end

    def authenticate(login, password)
      profile = Profile.find_by_login(login)

      if profile.present? and profile.password_correct?(password)
        profile
      else
        raise I18n.t(:invalid_user)
      end
    end

    def extract_keys_to_prevent_vandals(hash, keys)
      h = hash.extract!(*keys)
      h.keys.each {|key| h.delete(key) if h[key].nil?}
      return h
    end

  end
  
  begin "Partner Service"
  
    class << self
      
      def check_partner_params(params)
        %w{login password email partner forward}.each { |key|
          value = params[key] || params[key.to_sym]
          return false if value.blank?
        }
        return true
      end
      
      # login = partner_login
      def register_or_login(params)
        login = "#{params[:partner]}_#{params[:login]}"
        if Profile.find_by_login(login).blank?
          options = {}
          options[:login] = login
          options[:password] = params[:password]
          options[:mail] = params[:email]
          options[:user_type] = "student"
          options[:from_partner] = params[:partner]
          profile = Profile.new(options)
          profile.save
        else
          profile = Profile.authenticate(login, params[:password])
        end
        return profile
      end

    
    end      
    
  end

end
