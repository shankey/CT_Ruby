class UserController < ApplicationController
  include get_current_user
  def index
    current_user = get_current_user
  end
end
