class CreateUserPasswords < ActiveRecord::Migration[5.2]
  def change
    create_table :user_passwords do |t|
      t.belongs_to :user, index: true
      t.string :password_hash
      t.string :password_salt
      t.timestamps
    end
  end
end
