class Article < ActiveRecord::Base
	belongs_to :category
	belongs_to :user, foreign_key: 'account_id'
	has_many :comments

	def add_comments(*cmts)
		self.comments << cmts
		self[:commented_at] = cmts.last.created_at
		save
	end
end
