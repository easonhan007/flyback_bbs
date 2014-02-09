#encoding: utf-8
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

	def title_with_more_info
		title = self[:title]
		title = '[精]' + title if self[:great]
		title = '[置顶]' + title if self[:top]
		title
	end

	# when create a new post 
	# make sure last commenter is the creator
	# make sure last commented at is current timestamp
	def set_last_commentor_and_last_commented_at user
		return unless user.is_a?(Account)
		self[:commented_by] = user.name
		self[:commented_at] = self[:created_at]
	end

end
