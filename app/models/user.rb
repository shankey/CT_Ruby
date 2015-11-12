class User < ActiveRecord::Base
    
    has_secure_password
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

  # Returns a random token.
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
  
    def remember
        update_attribute(:remember_digest, User.get_remember_digest)
    end
  
end
