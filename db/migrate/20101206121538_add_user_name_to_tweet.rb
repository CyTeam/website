class AddUserNameToTweet < ActiveRecord::Migration
  def self.up
    add_column :tweets, :user_name, :string
  end

  def self.down
    remove_column :tweets, :user_name
  end
end
