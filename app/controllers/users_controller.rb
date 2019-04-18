class UsersController < ApplicationController
  before_action :set_user, only: []

  # POST /users
  def create
    @user = User.new(user_params)
    salt = BCrypt::Engine.generate_salt
    password = BCrypt::Engine.hash_secret(params['password'], salt)
    up = UserPassword.create(user_id: @user.id, password_salt: salt, password_hash: password)
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.user_password.password_hash == BCrypt::Engine.hash_secret(params['password'], @user.user_password.password_salt)
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {status: 'password missmatch'}
    end
  end

  def login
    @existing_user = User.find_by_email(params['email'])
    if @existing_user
      if @existing_user.user_password.password_hash == BCrypt::Engine.hash_secret(params['password'], @existing_user.user_password.password_salt)
        render json: @existing_user
      else
        render json: {status: 'exists'}
        return
      end
    else
      render json: {status: false}
      return
    end
  end

  # DELETE /users/1
  def destroy
    # @user.destroy
    render json: {action: false}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :profile_picture)
    end
end
