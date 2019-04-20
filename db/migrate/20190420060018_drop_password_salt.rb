class DropPasswordSalt < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_passwords, :password_salt
  end
end
