class User < Account
  has_many :articles, foreign_key: 'account_id'
  has_many :comments, foreign_key: 'account_id'

  before_validation do
    self[:role] = 'user' 
  end

end
