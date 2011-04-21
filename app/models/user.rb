class User < ActiveRecord::Base
  attr_accessible :name, :email, :id, :node
  has_many :messages
  # after_initialize :set_uuid
  validates_presence_of :name
  
  include ShardingHelper
  
  # def calc_node
  #   node_from_uuid(params[:id])
  # end
  
  def User.calc_node(params)
    # puts params[:id]
    node_from_uuid(params[:id])
    # params[:id].gsub('-','').hex.to_i % NODES
  end
end
