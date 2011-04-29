class Shard < ActiveRecord::Base
  NODES = 1024
  has_many :children, :class_name => "Shard", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Shard"
  
  validates_presence_of :parent_id
  before_create :set_number
  
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
      
  
  def self.node_from_uuid(uuid)
    uuid.gsub('-','').hex.to_i % NODES
  end
  
  
  def self.which(uuid)
    node = Shard.node_from_uuid(uuid)
    shard_number = node % Shard.count
    Shard.find_by_number(shard_number)
  end
  
end