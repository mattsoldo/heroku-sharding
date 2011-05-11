class Shard < ActiveRecord::Base
  NODES = 1024
  has_many :children, :class_name => "Shard", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Shard"
  
  # validates_presence_of :parent_id
  before_create :set_number
  
  scope :shard_only, where(:hotstandby => false)
  
  def set_number
    if parent
      self.number = parent.number + (Shard.octopus_count / 2)
    else
      self.number = 0
    end
  end

  def Shard.names
    Shard.all.map {|shard| shard.name}
  end

  def Shard.octopus_hash
    Octopus.config[Octopus.rails_env]["shards"]
  end
  
  def Shard.octopus_names
    Shard.octopus_hash.keys
  end

  # Used to figure out which shards do no have records
  def Shard.unused_names
    Shard.octopus_names - Shard.names
  end
      
  def key
    name.to_sym
  end

  def to_s
    "#{number}: #{name}"
  end
    
  def Shard.octopus_count
    Octopus.config[Octopus.rails_env]["shards"].count
  end
    
  def Shard.node_from_uuid(uuid)
    uuid.gsub('-','').hex.to_i % NODES
  end
    
  def Shard.find_by_uuid(uuid)
    node = Shard.node_from_uuid(uuid)
    shard_number = node % Shard.shard_only.count
    Shard.find_by_number(shard_number)
  end
  
  def heroku_name
    return "HEROKU_POSTGRESQL_#{name.upcase}"
  end
  
  def track(password)
    heroku = Heroku::Client.new(ENV['HEROKU_USERNAME'], password)
    old_config_vars = heroku.config_vars(ENV['HEROKU_APP_NAME'])
    heroku.install_addon(ENV['HEROKU_APP_NAME'], 'heroku-postgresql:ika', {:track => self.heroku_name})
    new_config_vars = heroku.config_vars(ENV['HEROKU_APP_NAME'])
    new_db_name = new_config_vars.keys - old_config_vars.keys
    new_db_url = new_config_vars.values - old_config_vars.values
    Shard.create(
      :parent => self, 
      :url => new_db_url, 
      :name => new_db_name.split('_').last, 
      :hotstandby => true
      )
  end
end