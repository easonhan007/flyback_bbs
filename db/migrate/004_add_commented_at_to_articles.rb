class AddCommentedAtToArticles < ActiveRecord::Migration
  def self.up
  	add_column :articles, :commented_at, :datetime
  end

  def self.down
  	remove_column :articles, :commented_at
  end
end
