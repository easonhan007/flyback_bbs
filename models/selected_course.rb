class SelectedCourse < ActiveRecord::Base
	belongs_to :account
	belongs_to :course
end
