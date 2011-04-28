module ShardingHelper
  
  # NODES = 1024
  
  def self.included(base)
    base.extend(ClassMethods)
    class << base
      alias_method_chain :create, :sharding
    end
  end

  # def set_uuid
  #   self.id = UUIDTools::UUID.random_create.to_s
  # end
  
  # def set_node
  #   self.node = self.calc_node(self)
  # end

  # def node_from_uuid
  #   uuid_int % NODES
  # end
  #   
  # def uuid_int(uuid)
  #   uuid.gsub('-','').hex.to_i
  # end
  
  # def node_from_relation(relation)
  #   relation.node
  # end
  # 
  # def set_current_shard
  #   Shard.which(self.node)
  # end
  # 
  # def node_from_uuid(uuid)
  #   uuid.gsub('-','').hex.to_i % NODES
  # end
  
  
  module ClassMethods
    # def node_from_uuid(uuid)
    #   uuid.gsub('-','').hex.to_i % NODES
    # end
    
    def create_with_sharding(params)
      object = self.new(params)
      object.id = UUIDTools::UUID.random_create.to_s
      object.node = Shard.node_from_uuid(object.id)
      shard = Shard.which(object.id)
      self.using(shard).create_without_sharding(object.attributes)
    end
    
    # def old_create_with_sharding(params)
    #   params[:id] = UUIDTools::UUID.random_create.to_s
    #   params[:node] = self.calc_node(params)
    #   puts params[:node]
    #   shard = Shard.which(params[:node])
    #   self.using(shard).create_without_sharding(params)
    # end    
    # 
    # def older_create_with_sharding(params)
    #   object = self.new(params)
    #   
    #   object.using(Shard.which(object.node)).save
    # end
  end
end
