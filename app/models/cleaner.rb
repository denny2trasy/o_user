module  Cleaner

  module  Session
    
    # Just for removing the day before today session, make record small
    # ActiveRecord::SessionStore::Session just include 10 hours
    def self.remove_expired_session(interval = 10)
      ActiveRecord::SessionStore::Session.where("updated_at <= ? ", interval.hours.ago).delete_all
    end
  
  end

end