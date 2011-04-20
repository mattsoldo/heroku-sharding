class User < ActiveRecord::Base
  attr_accessible :name, :email
  has_many :messages
  before_create :set_uuid
  validates_presence_of :name
  
  include ShardingHelper
end
