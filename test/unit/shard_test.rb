require 'test_helper'

class ShardTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Shard.new.valid?
  end
end
