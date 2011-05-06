class Message < ActiveRecord::Base
  # attr_accessible :user, :body, :user_id, :id, :node
  belongs_to :user
  before_create :set_uuid
  validates_presence_of :body
  
  include UUIDForID
  
  def Message.create_with_sharding(params)
    Message.using(Shard.find_by_uuid(params[:user_id]).key).create(params)
  end
end
