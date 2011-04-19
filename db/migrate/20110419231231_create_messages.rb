class CreateMessages < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE messages (
              id          UUID  PRIMARY KEY,
              user_id     UUID  REFERENCES users (id),  
              message     varchar(255),
              created_at  timestamp,
              updated_at  timestamp,
              node  smallint
            )"
    add_index :messages, :user_id
    
  end

  def self.down
    drop_table :messages
  end
end
