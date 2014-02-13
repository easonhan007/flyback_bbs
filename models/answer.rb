class Answer < ActiveRecord::Base
	belongs_to :question
	belongs_to :account
	belongs_to :test_result

	before_save :fetch_test_result_id

	private
		def fetch_test_result_id
			test_id = question.test.id
			result = TestResult.find_or_create_by_account_id_and_test_id(self[:account_id], test_id)
			self[:test_result_id] = result.id
		end
end
