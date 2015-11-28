module UserHelper
  def get_current_user
    return User.find_by_id(session[:current_user_id])
  end
end
