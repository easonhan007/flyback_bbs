class Article < ActiveRecord::Base
	belongs_to :category
	has_many :comments

	def add_comments(*cmts)
		self.comments << cmts
		self[:commented_at] = cmts.last.created_at
		save
	end
end
