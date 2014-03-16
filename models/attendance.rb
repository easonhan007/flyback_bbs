class Attendance < ActiveRecord::Base

  belongs_to :course
  belongs_to :account

end
