class CreateUsers < ActiveRecord::Migration
  def self.up
    # create_table :users do |t|
    #   t.UUID :id
    #   t.string :name
    #   t.string :email
    #   t.timestamps
    # end
    
    execute "CREATE TABLE users (
              id    UUID          PRIMARY KEY, 
              name  varchar(255), 
              email varchar(255),
              created_at  timestamp,
              updated_at  timestamp,
              node  smallint
            )"
  end

  def self.down
    drop_table :users
  end
end
