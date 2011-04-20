class Message < ActiveRecord::Base
  attr_accessible :user, :body, :user_id
  belongs_to :user
  before_create :set_uuid
  validates_presence_of :body
  
  include ShardingHelper
  
end
