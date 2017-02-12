# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#  created_at          :datetime
#  updated_at          :datetime
#  name                :string
#  facebook_id         :string
#  facebook_data       :text
#

# add top level class documentation
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable
  has_many :tasks

  def tasks_done
    tasks.commited.count
  end

  def pages_done
    return 0 unless active_task
    active_task.pages.done.count
  end

  def pages_left
    active_task.pages.free.count
  end

  def encrypted_password
    false
  end

  def active_task
    tasks.active.first
  end
end
