class User < ActiveRecord::Base
  has_secure_password
  # We should enable the following once we have migrated all the existing users.
  # validates_presence_of :email, :password
  validates_uniqueness_of :email

  # Returns false if the user verification failed, else returns the
  # user object itself.
  def User.verify_user(email, password)
    user = User.find_by_email(email)
    if !user
      return false
    else
      return user.authenticate(password)
    end
  end
end
