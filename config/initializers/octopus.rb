## hash of the shards we will create
## the all_shards key contains an embedded hash used to group the shards
# shards = {:all_shards => {}}
# require 'octopus'
shards = {}
ENV.each_with_index do |env_variable, index|
  # Test if its a Heroku PostgreSQL URL
  if env_variable[0] =~ /HEROKU_POSTGRESQL_[A-Z]+_URL/
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
 
# Octopus.setup do |config|
#   config.environments = [:production]
#   config.shards = shards
# end

# Octopus.shards = {
#     :production => {
#       :white_shard => {
#         :adapter => "postgresql", 
#         :database => "dj21lsmiewecscn", 
#         :username => "uf3ljol7ufl6wji", 
#         :password => "p7fz8kjndmo8y4ia3omwk8mre3", 
#         :host => "ec2-50-19-122-152.compute-1.amazonaws.com"
#       },
#       :yellow_shard => {
#         :adapter => "postgresql", 
#         :database => "dc37wq7vnsskr83", 
#         :username => "uy2nwf64mvc59tm", 
#         :password => "pa93p1b6acd4fcrcmdbt5qbxox", 
#         :host => "ec2-50-19-122-155.compute-1.amazonaws.com"
#       }
#     }
#   }
