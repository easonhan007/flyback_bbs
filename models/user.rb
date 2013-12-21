class User < Account

  before_validation do
    self[:role] = 'user' 
  end

end
