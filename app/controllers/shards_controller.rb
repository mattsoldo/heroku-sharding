class ShardsController < ApplicationController
  def index
    @shards = Shard.order(:number).all
  end

  def show
    @shard = Shard.find(params[:id])
    @users = User.using(@shard.key).order(:id).limit(1000).all
  end

  def new
    @shard = Shard.new
  end

  def create
    @shard = Shard.new(params[:shard])
    if @shard.save
      redirect_to @shard, :notice => "Successfully created shard."
    else
      render :action => 'new'
    end
  end

  def edit
    @shard = Shard.find(params[:id])
  end

  def update
    @shard = Shard.find(params[:id])
    if @shard.update_attributes(params[:shard])
      redirect_to @shard, :notice  => "Successfully updated shard."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @shard = Shard.find(params[:id])
    @shard.destroy
    redirect_to shards_url, :notice => "Successfully destroyed shard."
  end
  
  def rebalance
    User.rebalance_shards
    redirect_to shards_url, :notice => "Successfully rebalanced shard."
  end
end
