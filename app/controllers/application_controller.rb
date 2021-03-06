class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :admin

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def admin
    return nil if not current_user
    current_user.admin
  end

  def ensure_that_signed_in
  	redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
    ensure_that_not_frozen
  end

  def ensure_that_admin
    redirect_to :back, notice:'you don''t have rights for that' if current_user.nil? or not current_user.admin
  end

  def ensure_that_not_frozen
    redirect_to signin_path, notice:'Your account is frozen, please contact admin' if current_user.disabled
  end
end
