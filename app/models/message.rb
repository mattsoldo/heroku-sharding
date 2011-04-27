class Message < ActiveRecord::Base
  # attr_accessible :user, :body, :user_id, :id, :node
  belongs_to :user
  before_create :set_uuid
  validates_presence_of :body
  
  # include ShardingHelper
  def set_uuid
    self.id = UUIDTools::UUID.random_create.to_s
  end

end
