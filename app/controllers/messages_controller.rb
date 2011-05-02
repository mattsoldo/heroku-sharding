class MessagesController < ApplicationController
  around_filter :select_shard      

  def select_shard(&block)
    Octopus.using(Shard.find_by_uuid(params[:user_id]).key, &block)
  end
    
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    user = User.find(params[:user_id])
    @message = user.messages.build(params[:message])
    # @message = Message.new(params[:message])
    if @message.save
      redirect_to user, :notice => "Successfully created message."
    else
      redirect_to user, :notice => "Message not created."
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      redirect_to @message, :notice  => "Successfully updated message."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to messages_url, :notice => "Successfully destroyed message."
  end
end
