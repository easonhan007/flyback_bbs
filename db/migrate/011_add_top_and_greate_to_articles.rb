class AddTopAndGreateToArticles < ActiveRecord::Migration
  def self.up
  	add_column :articles, :top, :boolean, default: false
  	add_column :articles, :great, :boolean, default: false
  end

  def self.down
  	remove_column :articles, :top
  	remove_column :articles, :great
  end
end
