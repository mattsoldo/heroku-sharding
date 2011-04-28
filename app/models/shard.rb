class Shard
  NODES = 1024
  attr_accessor :name, :number
  
  def initialize(name)
    if REDIS.keys.include?(name.to_s)
      @name = name.to_sym
      @number = REDIS.get(name.to_s).to_i
    else
      return false
    end
  end
  
  def self.all
    self.names.each.map {|name| Shard.new(name)}
  end
  
  def purge(class_name)
    class_name.send(:using,self.name).send(:not_on_shard,self.number,Shard.count).send(:delete_all)
  end
  
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
    Octopus.config[Octopus.rails_env]["shards"].keys
  end
  
  def self.store_in_redis
    Shard.names.each_with_index do |name, index|
      REDIS.set(index, name)
      REDIS.set(name, index)
    end
  end
  
  def self.node_from_uuid(uuid)
    uuid.gsub('-','').hex.to_i % NODES
  end
  
  # Requires that object responds to .node method with an integer
  def self.which_from_node(node)
    shard_number = node % Shard.count
    REDIS.get(shard_number).to_sym
  end
  
  def self.which(uuid)
    node = Shard.node_from_uuid(uuid)
    shard_number = node % Shard.count
    REDIS.get(shard_number).to_sym
  end
  
  def self.find(id)
    ## UUID
    if id.is_a? Symbol
      # Just return the symbol
      return Shard.new(id)
    elsif id.is_a? String
      id = Shard.node_from_uuid(id)
    ## Node
    elsif id.is_a? Integer
      # Nothing to do
    else
      return nil
    end
    return Shard.new(REDIS.get(id % Shard.count))
  end
end