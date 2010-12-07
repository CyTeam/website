require 'grackle'

class Tweet < ActiveRecord::Base
  include Twitter::Autolink

  MY_APPLICATION_NAME = RefinerySetting.get(:twitter_user)

  default_scope :order => "created DESC"
  scope :latest, lambda { |*l_params|
    limit( l_params.first || 20)
  }

  def self.get_latest
    tweets = client.statuses.home_timeline? :screen_name => MY_APPLICATION_NAME # hit the API
    tweets.each do |t|
      created = Time.zone.parse(t.created_at)
      
      # create the tweet if it doesn't already exist
      unless Tweet.exists?(:created => created)
        Tweet.create({:content => t.text, :created => created.to_s, :user_name => t.user.screen_name })
       end
    end
  end

  def linked_content
    auto_link(content)
  end

  def user_link
    "http://twitter.com/#{user_name}"
  end

  def self.test
    puts RefinerySetting.get(:twitter_consumer_key)
  end

  private
  def self.client
    Grackle::Client.new(:auth=>{
      :type =>            :oauth,
      :consumer_key =>    RefinerySetting.get(:twitter_consumer_key),
      :consumer_secret => RefinerySetting.get(:twitter_consumer_secret),
      :token =>           RefinerySetting.get(:twitter_token),
      :token_secret =>    RefinerySetting.get(:twitter_token_secret)
    })
  end
end