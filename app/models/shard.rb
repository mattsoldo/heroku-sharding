class Shard < ActiveRecord::Base
  NODES = 1024
  has_many :children, :class_name => "Shard", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Shard"
  
  validates_presence_of :parent_id
  before_create :set_number
  
  # def initialize(name)
  #   if REDIS.keys.include?(name.to_s)
  #     @name = name.to_sym
  #     @number = REDIS.get(name.to_s).to_i
  #   else
  #     return false
  #   end
  # end
  
  # def self.all
  #   self.names.each.map {|name| Shard.new(name)}
  # end
  
  # def purge(class_name)
  #   class_name.send(:using,self.name).send(:not_on_shard,self.number,Shard.count).send(:delete_all)
  # end
  
  # def self.count
  #   Octopus.config[Octopus.rails_env]["shards"].count
  # end    

  # def depth
  #   Math.log2(self.count).to_i
  # end

  def set_number
    self.number = parent.number + (Shard.octopus_count / 2)
  end

  def key
    name.to_sym
  end

  def to_s
    "#{number}: #{name}"
  end
  
  def self.octopus_hash
    Octopus.config[Octopus.rails_env]["shards"]
  end
  
  def self.octopus_names
    Shard.octopus_hash.keys
  end
  
  def self.octopus_count
    Octopus.config[Octopus.rails_env]["shards"].count
  end
  
  def self.names
    Shard.all.map {|shard| shard.name}
  end

  # Used to figure out which shards do no have records
  def self.unused_names
    Shard.octopus_names - Shard.names
  end
      
  # def self.store_from_octopus
  #   Shard.delete_all
  #   Shard.octopus_names.each_with_index do |name, index|
  #     Shard.create(:name => name, :number => index)
  #   end
  # end
  
  
  # def self.store_in_redis
  #   Shard.names.each_with_index do |name, index|
  #     REDIS.set(index, name)
  #     REDIS.set(name, index)
  #   end
  # end
  
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
    Shard.find_by_number(shard_number).key
    # REDIS.get(shard_number).to_sym
  end
  
  # def self.find(id)
  #   ## UUID
  #   if id.is_a? Symbol
  #     # Just return the symbol
  #     return Shard.new(id)
  #   elsif id.is_a? String
  #     id = Shard.node_from_uuid(id)
  #   ## Node
  #   elsif id.is_a? Integer
  #     # Nothing to do
  #   else
  #     return nil
  #   end
  #   return Shard.new(REDIS.get(id % Shard.count))
  # end
end