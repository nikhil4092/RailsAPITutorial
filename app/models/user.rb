class User < ApplicationRecord
    has_one :user_password, dependent: :delete
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, on: :create
end
