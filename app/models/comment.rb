# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string
#  upvotes    :integer
#  post_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

# add top level class documentation
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  def as_json(options = {})
    super(options.merge(include: :user))
  end
end
