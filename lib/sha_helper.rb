require 'digest/sha1'
class ShaHelper
  class << self

    def encrypt(salt, raw_data)
      require 'openssl' unless defined?(OpenSSL)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, salt, raw_data.to_s)
    end

    def salt
      ActiveSupport::SecureRandom.hex(64)
    end
    
    def encrypt_util(data)
      Digest::SHA1.hexdigest(data)
    end

  end
end
