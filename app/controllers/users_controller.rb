class UsersController < ApplicationController
  around_filter :select_shard, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    if @user = User.create(params[:user])
    # uuid = 
    # @user = User.new(params[:user])
    # @user.id = UUIDTools::UUID.random_create.to_s
    # @user.node = Shard.node_from_uuid(@user.id)
    # shard = Shard.find_by_uuid(user.id)
    # if @user.using(shard.key).save
      redirect_to @user, :notice => "Successfully created user."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :notice  => "Successfully updated user."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, :notice => "Successfully destroyed user."
  end
  
  private

  def select_shard(&block)
    Octopus.using(Shard.find_by_uuid(params[:id]).key, &block)
  end

end
