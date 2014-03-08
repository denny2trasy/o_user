class PartnerService
  def self.authenticate(course_package,userID,partner_name,key)
    pwd = "eleuidap8n"
    str =  userID + partner_name + course_package + pwd
    Digest::MD5.hexdigest(str) == key ? true : false
  end
end