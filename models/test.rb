class Test < ActiveRecord::Base
	belongs_to :course
	has_many :tests
end
