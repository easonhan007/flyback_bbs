class Comment < ActiveRecord::Base
	belongs_to :article
	belongs_to :user, foreign_key: 'account_id'

	validates :content, presence: true, length: {minimum: 10}
end
