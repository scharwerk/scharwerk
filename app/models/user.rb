class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable

  def encrypted_password
    false
  end
end
