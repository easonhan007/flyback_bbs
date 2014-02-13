class Test < ActiveRecord::Base
	belongs_to :course
	has_many :questions
	has_many :test_results, order: 'updated_at DESC'
end
