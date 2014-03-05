class Course < ActiveRecord::Base
	has_many :selected_courses
	has_many :tests
	has_many :accounts, through: :selected_courses
	has_many :attendances
end
