class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
			t.text :content      
			t.belongs_to :account
			t.belongs_to :question
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
