class UsersController < ApplicationController
  include BCrypt
  # POST /users
  def create
    @user = User.new(user_params)
    if !params['password'].nil?
      password = Password.create(params['password'])
      if @user.save
        up = UserPassword.create(user_id: @user.id, password_hash: password)
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {status: 'no password'}
    end
  end

  # PATCH/PUT /users/1
  def update
    @db_password = Password.new(@user.user_password.password_hash)
    if @db_password == params['password']
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
      @db_password = Password.new(@existing_user.user_password.password_hash)
      if @db_password == params['password']
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
