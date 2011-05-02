class User < ActiveRecord::Base  
  attr_accessible :name, :email, :id, :node
  has_many :messages
  validates_presence_of :name
  
  scope :on_shard, lambda {|shard| where("node % #{Shard.count} = #{shard.number}") }
  scope :not_on_shard, lambda {|shard| where("node % #{Shard.count} != #{shard.number}") }
  
  def to_s
    "#{id}: #{name}, #{email}"
  end
  
  class << User
    def create_with_sharding(params)
      user = self.new(params)
      user.id = UUIDTools::UUID.random_create.to_s
      user.node = Shard.node_from_uuid(user.id)
      shard = Shard.find_by_uuid(user.id)
      User.using(shard.key).create_without_sharding(user.attributes)
    end
    
    def rebalance_shards
      Shard.all.each do |shard|
        # Delete all of the users that shouldn't be on this shard
        User.using(shard.key).where("node % #{Shard.count} != #{shard.number}").delete_all()
      end
    end

    def total_count
      count = 0
      Shard.all.each do |shard|
        count += User.using(shard.key).count
      end
      return count
    end
    
    alias_method_chain :create, :sharding
  end
end
