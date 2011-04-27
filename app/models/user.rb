class User < ActiveRecord::Base
  attr_accessible :name, :email, :id, :node
  has_many :messages
  validates_presence_of :name
  include ShardingHelper
  
  def to_s
    "#{id}: #{name}, #{email}"
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
