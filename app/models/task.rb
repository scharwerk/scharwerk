# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  status     :integer
#  stage      :integer
#  part       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Task < ActiveRecord::Base
  belongs_to :user

  # enum status: {new: 0, in_progress: 1, done: 2, commited: 3}
  # enum stage: {recognized: 0, first_proof: 1, second_proof: 2}
  # enum part: {book_1: 1, book_2: 2, book_3_1: 3, book_3_2: 4}  
end
