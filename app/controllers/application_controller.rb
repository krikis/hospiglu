class ApplicationController < ActionController::Base

  protect_from_forgery

  private

  def init_from_session
    @brainstorm = Brainstorm.find_by_id session[:brainstorm_id]
    @user = User.find_by_id session[:user_id]
  end

end
