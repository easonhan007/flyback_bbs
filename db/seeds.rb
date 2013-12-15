# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
# email     = shell.ask "Which email do you want use for logging into admin?"
# password  = shell.ask "Tell me the password to use:"

# shell.say ""

# account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

# if account.valid?
#   shell.say "================================================================="
#   shell.say "Account has been successfully created, now you can login with:"
#   shell.say "================================================================="
#   shell.say "   email: #{email}"
#   shell.say "   password: #{password}"
#   shell.say "================================================================="
# else
#   shell.say "Sorry but some thing went wrong!"
#   shell.say ""
#   account.errors.full_messages.each { |m| shell.say "   - #{m}" }
# end

# shell.say ""

require 'pp'
# delete all categories and articles and comments
shell.say 'Delete all catetoris, articles and comments now...'
del_category = "delete from #{Category.table_name}"
del_article = "delete from #{Article.table_name}"
del_comment = "delete from #{Comment.table_name}"
del_account = "delete from #{Account.table_name}"
ActiveRecord::Base.connection.execute del_category
ActiveRecord::Base.connection.execute del_article
ActiveRecord::Base.connection.execute del_comment
ActiveRecord::Base.connection.execute del_account

shell.say 'Add an user' 
eason = User.create(name: 'eason', password: 'user', password_confirmation: 'user', email: 'eason@flybackbbs.com')
lily = User.create(name: 'lily', password: 'user', password_confirmation: 'user', email: 'lily@flybackbbs.com')
lucy = User.create(name: 'lucy', password: 'user', password_confirmation: 'user', email: 'lucy@flybackbbs.com')

shell.say 'Add new category python'
c = Category.create(name: 'python', description: 'group for python topics') 

shell.say 'Add topics for python'
topic1 = Article.new(title: 'Why python is great', content: 'why python is greate')
topic2 = Article.new(title: 'How long do you use python', content: 'How long do you use python')
c.articles << [topic1, topic2]
eason.articles << [topic1, topic2]

shell.say 'Add new category ruby'
c = Category.create(name: 'ruby', description: 'group for ruby topics') 

shell.say 'Add topics for ruby'
topic1 = Article.new(title: 'Why ruby is great', content: 'why ruby is greate')
topic2 = Article.new(title: 'How long do you use ruby', content: 'How long do you use ruby')
c.articles << [topic1, topic2]
lucy.articles << [topic1, topic2]

shell.say 'Add comment to topic'
comment1 = Comment.new(content: 'ruby is beautiful')
comment2 = Comment.new(content: 'I agree')
comment3 = Comment.new(content: 'ROR works great, I like it')
eason.comments << [comment1, comment2]
lucy.comments << comment3
topic1.add_comments comment1, comment2, comment3
comment4 = Comment.new(content: '5 years')
# topic2.comments << comment4
topic2.add_comments comment4
lily.comments << comment4

# add a admin account
admin = Account.new(name: 'admin', email: 'admin@test.com', password: 'admin', password_confirmation: 'admin', role: 'admin')
if admin.valid? && admin.save
	shell.say 'Create admin'
else
	shell.say 'can not create admin'
end #if


