namespace :shard do
  desc "Add more shards and redistribute the data"
  task :track => :environment do
    heroku = Heroku::Client.new('me@example.com', 'mypass')
    existing_dbs = Shard.all
    existing_dbs.each do |db|
      # Create a tracker
      
    end
  end
  
  task :expand => :environment do
    puts "Sharding"
    existing_dbs = Shard.all
    existing_dbs.each do |db|
      # Create a tracker
    end
    ENV.each_with_index do |env_variable, index|
      # Test if its a Heroku PostgreSQL URL
      if env_variable[0] =~ /HEROKU_POSTGRESQL_[A-Z]+_URL/
        puts "forking #{env_variable[0]}"
        # the database name is the config var name with the trailing _URL
        database_name = env_variable[0..-5]
        exec 'heroku addons:add heroku:postgresql --fork #{database_name}'
        url = URI.parse(env_variable[1])
        
        # shards[:all_shards][index] = {
        shards[index] = {
          :adapter => "postgresql",
          :host     => url.host, 
          :database => url.path[1..-1], 
          :username => url.userinfo.split(':')[0], 
          :password => url.userinfo.split(':')[1]
          }
      end 
    end
  end
end