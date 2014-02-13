class Question < ActiveRecord::Base
	belongs_to :test
	has_many :answers

	def answer_of_user(user)
		return nil unless user.is_a?(Account)
		# logger.info user.id.to_s
		# logger.info self[:id].to_s
		return Answer.find_or_initialize_by_account_id_and_question_id(user.id, self[:id])
	end

end
