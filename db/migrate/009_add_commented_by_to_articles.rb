class AddCommentedByToArticles < ActiveRecord::Migration
  def self.up
  	add_column :articles, :commented_by, :string
  end

  def self.down
  	remove_column :articles, :commented_by
  end
end
