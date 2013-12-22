class Article < ActiveRecord::Base
	belongs_to :category
	belongs_to :user, foreign_key: 'account_id'
	has_many :comments

	validates :title, presence: true
	validates :content, presence: true
	validates :category_id, presence: true

	def add_comments(*cmts)
		self.comments << cmts
		self[:commented_at] = cmts.last.created_at
		self[:commented_by] = cmts.last.user.name
		save
	end
end
