class ShardsController < ApplicationController
  def index
    @shards = Shard.all
  end
end