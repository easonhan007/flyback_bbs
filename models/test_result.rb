class TestResult < ActiveRecord::Base
	has_many :answers
	belongs_to :account
	belongs_to :test
end
