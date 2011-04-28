class User < ActiveRecord::Base
  attr_accessible :name, :email, :id, :node
  has_many :messages
  validates_presence_of :name
  include ShardingHelper
  
  scope :on_shard, lambda {|shard| where("node % #{Shard.count} = #{shard.number}") }
  scope :not_on_shard, lambda {|shard| where("node % #{Shard.count} != #{shard.number}") }
  
  def to_s
    "#{id}: #{name}, #{email}"
  end
  
  def User.purge_shards
    Shard.all.each do |shard|
      User.using(shard.name).not_on_shard(shard).delete_all()
    end
  end
  
  def User.total_count
    count = 0
    Shard.all.each do |shard|
      count += User.using(shard.name).count
    end
    return count
  end
  
  # def calc_node
  #   node_from_uuid(params[:id])
  # end
  
  # def User.calc_node(params)
  #   # puts params[:id]
  #   node_from_uuid(params[:id])
  #   # params[:id].gsub('-','').hex.to_i % NODES
  # end
  
  # def self.create_with_sharding(params)
  #   user = User.new(params)
  #   shard = Shard.which(user.id)
  #   puts shard
  #   User.using(shard).create(user.attributes)
  # end
end
