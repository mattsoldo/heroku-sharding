class Message < ActiveRecord::Base
  # attr_accessible :user, :body, :user_id, :id, :node
  belongs_to :user
  before_create :set_uuid
  validates_presence_of :body
  
  # include ShardingHelper
  def User.calc_node(params)
    User.find(params[:user_id]).node
  end
end
