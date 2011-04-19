class Message < ActiveRecord::Base
  attr_accessible :user, :message
  belongs_to :user
  before_create :set_uuid
  
  include UUIDHelper
  
end
