class AddAccountIdToArticlesAndComments < ActiveRecord::Migration
  def self.up
  	add_column :articles, :account_id, :integer
  	add_column :comments, :account_id, :integer
  end

  def self.down
  	remove_column :articles, :account_id
  	remove_column :comments, :account_id
  end
end
