class User < ActiveRecord::Base
  attr_accessible :name, :email
  has_many :messages
  before_create :set_uuid
  
  include UUIDHelper
end
