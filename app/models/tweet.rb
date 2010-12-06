require 'grackle'

class Tweet < ActiveRecord::Base

  MY_APPLICATION_NAME = "CyT_GmbH"

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

  def user_link
    "http://twitter.com/#{user_name}"
  end

  private
  def self.client
    Grackle::Client.new(:auth=>{
      :type =>            :oauth,
      :consumer_key =>    'xt1O061VbWdJzWvwrUnXYA',
      :consumer_secret => 'J7Cd1y8ypFwZU9ZrrwO281PbBT2GsgDT5wjBYkhc',
      :token =>           '223437861-1DpwfBVP3As5KAJ6XnicaJH2bZckz6L6gJ3ys',
      :token_secret =>    'H0KMzW6t6tPDm12PqQSQtiJeGSFHTLnp2bcvgJn2VMI'
    })
  end
end