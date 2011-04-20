## hash of the shards we will create
## the all_shards key contains an embedded hash used to group the shards
shards = {:all_shards => {}}

ENV.each_with_index do |env_variable, index|
  # Test if its a Heroku PostgreSQL URL
  if env_variable[0] =~ /HEROKU_POSTGRESQL_[A-Z]+_URL/
    url = URI.parse(env_variable[1])
    shards[:all_shards][index] = {
      :adapter => "postgresql",
      :host     => url.host, 
      :database => url.path[1..-1], 
      :username => url.userinfo.split(':')[0], 
      :password => url.userinfo.split(':')[1]
      }
  end 
end
 
Octopus.setup do |config|
  config.shards = shards
  config.environments = [:production]
end