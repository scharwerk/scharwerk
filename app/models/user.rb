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
  has_many :restrictions
  has_many :restricted_tasks, through: :restrictions, source: :task
  devise :database_authenticatable, :registerable, :rememberable, :trackable
  has_many :tasks

  def total_pages_done
    tasks.joins(:pages).where('tasks.status IN (?)', Task.done_statuses).count
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

  def time_inactive
    Time.now - last_task.updated_at
  end

  def active_task
    tasks.active.first
  end

  def last_task
    tasks.commited.last
  end

  def self.find_or_create_user(fb_user)
    user = User.find_by(facebook_id: fb_user.id)
    return [:ok, user] if user

    user = User.new
    user.facebook_id = fb_user.id
    user.name = fb_user.name
    user.facebook_data = fb_user.raw_attributes.to_json
    user.save

    [:created, user]
  end

  def self.login(access_token)
    fb_user = FbGraph2::User.me(access_token).fetch(fields: 'id,
      name,
      age_range,
      gender,
      locale,location')

    status, user = find_or_create_user(fb_user)
    user.update(token: access_token)

    [status, user]
  end

  def self.stats_users(stages=nil)
    t = joins(tasks: :pages).where('tasks.status IN (?)', Task.done_statuses)
    t = t.where('tasks.stage IN (?)', stages) if stages
    t.select('users.name as name, COUNT(pages.*) AS done')
      .group('users.id')
      .order('done DESC')
  end
end
