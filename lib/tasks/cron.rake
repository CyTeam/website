task :cron => :environment do
  puts "Pulling new tweets."
  Tweet.get_latest
  puts "Done."
end
