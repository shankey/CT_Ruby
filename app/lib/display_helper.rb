module DisplayHelper
  def user_present(user)
    return !(user.blank? || user.name.blank?)
  end

  def get_log_in_display(user)
    if user_present(user)
      return "none"
    else
      return "block"
    end
  end

  def get_log_out_display(user)
    if user_present(user)
      return "block"
    else
      return "none"
    end
  end
end
