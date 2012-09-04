require 'helper'

class ElasticRecord::Index::ManageTest < MiniTest::Spec
  def setup
    super

    index.delete_all
  end
  
  def test_create
    assert !index.exists?('widgets_foo')

    index.create 'widgets_foo'

    assert index.exists?('widgets_foo')
  end

  def test_exists
    index.create 'widgets_foo'

    assert index.exists?('widgets_foo')
    assert !index.exists?('widgets_bar')
  end

  def test_deploy
    index.create 'widgets_foo'
    
    assert_nil index.deployed_name
    index.deploy 'widgets_foo'

    assert_equal 'widgets_foo', index.deployed_name
  end

  private
    def index
      @index ||= Widget.elastic_index
    end
end