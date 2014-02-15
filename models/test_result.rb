class TestResult < ActiveRecord::Base
	has_many :answers
	belongs_to :account
	belongs_to :test

	def finished_at
		answers.order('updated_at DESC').first.updated_at
	end

end
