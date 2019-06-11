class Api::V1::SessionsController < Devise::SessionsController
  before_action :find_user, only: :create
  before_action :validate_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy
  #Method for sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      json_response "Signed in successfully", true, {user: @user}, :ok
    else
      json_response "Unauthorized", false, {}, :unauthorized
    end    
  end

  #Method for logout
  def destroy
    sign_out @user
    @user.generate_new_authentication_token
    json_response "Logout successfully", true, {}, :ok
  end

  private

  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def find_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user 
    else
      json_response "User not found", false, {}, :failure
    end    
  end

  def validate_token
    @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
    if @user
      return @user 
    else
      json_response "Invalid Token", false, {}, :failure
    end
  end
    
end