class User < ApplicationRecord
    has_one :user_password, dependent: :delete
    validates :full_name, presence: true
    validates :email, presence: true, uniqueness: true, on: :create
end
