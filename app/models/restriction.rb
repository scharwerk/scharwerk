# The class hold data about what tasks should not be asigned to user.
class Restriction < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
end
