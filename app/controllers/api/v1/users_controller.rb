class Api::V1::UsersController < ApplicationController

  def create
    if params[:password] != params[:password_confirmation]
      render json: {status: 400, errors: ["Passwords do not match."]}, status: 400
    else
      @user = User.create(user_params)
      if !@user.save
        message = @user.errors.full_messages.uniq
        render json: {status: 400, errors: message}, status: 400
      else
        render json: UserSerializer.new(@user)
      end
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
