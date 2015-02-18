class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by username: params[:username]
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.disabled
        ensure_that_not_frozen
      else
        redirect_to @user, notice: "Welcome #{@user.username}!"
      end
    else
      redirect_to :back, notice: "User #{params[:username]} does not exist!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end