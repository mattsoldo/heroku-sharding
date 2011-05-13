class Shard < ActiveRecord::Base
  NODES = 1024
  has_many :children, :class_name => "Shard", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Shard"
  
  # validates_presence_of :parent_id
  before_create :set_number
  
  scope :masters, where(:hotstandby => false)
  scope :mirrors, where(:hotstandby => true)
  
  def set_number
    if parent
      ## This algorithm expects an even number of shards, so manually set it if there is only one
      if Shard.octopus_count == 1  
        self.number = 1
      else 
        self.number = parent.number + (Shard.octopus_count / 2)
      end
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
    shard_number = node % Shard.masters.count
    Shard.find_by_number(shard_number)
  end
  
  def heroku_name
    return "HEROKU_POSTGRESQL_#{name.upcase}"
  end
  
  def track
    heroku = Heroku::Client.new(ENV['HEROKU_USERNAME'], ENV['HEROKU_PASSWORD')
    old_config_vars = heroku.config_vars(ENV['HEROKU_APP_NAME'])
    heroku.install_addon(ENV['HEROKU_APP_NAME'], 'heroku-postgresql:ika', :track => self.url)
    new_config_vars = heroku.config_vars(ENV['HEROKU_APP_NAME'])
    new_db_name = (new_config_vars.keys - old_config_vars.keys).first
    new_db_url = (new_config_vars.values - old_config_vars.values).first
    Shard.create(
      :parent => self, 
      :url => (new_config_vars.values - old_config_vars.values).first, 
      :name =>  (new_config_vars.keys - old_config_vars.keys).first.split('_')[-2].downcase, 
      :hotstandby => true
      )
  end
  
  def detach
    database = HerokuPostgresql::Client10.new(self.url)
    database.untrack
    self.update_attributes(:hotstandby => false)
  end
  
  def Shard.create_trackers
    Shard.masters.each do |master|
      master.track
    end
  end
  
  def Shard.detach_trackers
    Shard.mirrors.each do |mirror|
      mirror.detach
    end
  end
end