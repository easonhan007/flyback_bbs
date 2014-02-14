#encoding: utf-8
class Test < ActiveRecord::Base
	belongs_to :course
	has_many :questions
	has_many :test_results, order: 'updated_at DESC'

	def result_status_by_user(user_id=nil)
		return '无法获取结果' if user_id.blank?
		begin
			result_of_user(user_id).passed?
		rescue
			'未知的'
		end 
	end

	def result_of_user(user_id=nil)
			test_results.where('account_id=?', user_id).first
	end

end
