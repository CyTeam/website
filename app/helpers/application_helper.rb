# Methods added to this helper will be available to all templates in the application.

# You can extend refinery with your own functions here and they will likely not get overriden in an update.
module ApplicationHelper
  include Refinery::ApplicationHelper # leave this line in to include all of Refinery's core helper methods.

  def home_news
    NewsItem.latest(2)
  end

  def tweets(amount = 2)
    Tweet.latest(amount)
  end
end
