class Shard
  def self.count
    Octopus.config[Octopus.rails_env]["shards"].count
  end    

  def depth
    Math.log2(self.count).to_i
  end

  def self.hash
    Octopus.config[Octopus.rails_env]["shards"]
  end
  
  def self.names
    Octopus.config[Octopus.rails_env]["shards"].keys.sort
  end
  
  def self.store_in_redis
    Shard.names.each_with_index do |name, index|
      REDIS.set(index, name)
    end
  end
  
  # Requires that object responds to .node method with an integer
  def self.which(node)
    shard_number = node % Shard.count
    REDIS.get(shard_number).to_sym
  end
end