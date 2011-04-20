class CreateUsers < ActiveRecord::Migration
  using_group(:all_shards)
  
  def self.up
    execute "CREATE TABLE users (
              id          UUID    PRIMARY KEY, 
              name        varchar(255), 
              email       varchar(255),
              created_at  timestamp,
              updated_at  timestamp,
              node        smallint
            )"
  end

  def self.down
    drop_table :users
  end
end
