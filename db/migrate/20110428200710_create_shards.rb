class CreateShards < ActiveRecord::Migration
  def self.up
    create_table :shards do |t|
      t.string :name
      t.integer :number
      t.references :parent
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :shards
  end
end
