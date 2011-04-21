module ShardingHelper  
  
  NODES = 1024
  
  def self.included(base)
    base.extend(ClassMethods)
    # base.after_initialize :set_uuid, :set_node
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
  
  def node_from_relation(relation)
    relation.node
  end
  
  def set_current_shard
    Shard.which(self.node)
  end
  
  def node_from_uuid(uuid)
    uuid.gsub('-','').hex.to_i % NODES
  end
  
  
  module ClassMethods
    def node_from_uuid(uuid)
      uuid.gsub('-','').hex.to_i % NODES
    end
    
    def create_with_sharding(params)
      params[:id] = UUIDTools::UUID.random_create.to_s
      params[:node] = self.calc_node(params)
      puts params[:node]
      shard = Shard.which(params[:node])
      self.using(shard).create_without_sharding(params)
    end    
    
    def old_create_with_sharding(params)
      object = self.new(params)
      
      object.using(Shard.which(object.node)).save
    end
  end
end
