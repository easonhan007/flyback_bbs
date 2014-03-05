class Attendance < ActiveRecord::Base

  belongs_to :coures
  belongs_to :accounts

end
