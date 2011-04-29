require 'test_helper'

class ShardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Shard.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Shard.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Shard.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to shard_url(assigns(:shard))
  end

  def test_edit
    get :edit, :id => Shard.first
    assert_template 'edit'
  end

  def test_update_invalid
    Shard.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Shard.first
    assert_template 'edit'
  end

  def test_update_valid
    Shard.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Shard.first
    assert_redirected_to shard_url(assigns(:shard))
  end

  def test_destroy
    shard = Shard.first
    delete :destroy, :id => shard
    assert_redirected_to shards_url
    assert !Shard.exists?(shard.id)
  end
end
