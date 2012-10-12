require File.dirname(__FILE__) + '/../test_helper'
require 'tag_controller'

# Re-raise errors caught by the controller.
class TagController; def rescue_action(e) raise e end; end

class TagControllerTest < Test::Unit::TestCase
  fixtures :photos
  fixtures :comatose_pages, :photo_sets
  fixtures :photos_photo_sets
  fixtures :posts
  fixtures :tags, :taggings

  def setup
    @controller = TagController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'tag/index'
    assert_tag_cloud
    
    # This will break if tags.yml is changed.
    # Font size = (sqrt(count) / sqrt(max_count)) * 125 + 25
    assert_select '#cloud' do
      assert_select %Q|a[style="font-size: 113%;"]|, {:text => 'a'}
      assert_select %Q|a[style="font-size: 150%;"]|, {:text => 'b'}
    end
  end
  
  def test_show_post_only
    get :show, :tag => 'a'
    assert_response :success
    assert_template 'tag/show'
    assert_tag_cloud
    assert_select "dl" do
      assert_select "dd", { :count => 2 }
      assert_select "a", { :text => Post.find(1).title }
      assert_select "div.thumb-card-xsmall", { :count => 0 }
    end
  end

  def test_show_photo_only
    get :show, :tag => 'c'
    assert_response :success
    assert_template 'tag/show'
    assert_tag_cloud
    assert_select "dl" do
      assert_select "dd", { :count => 1 }
      assert_select "div.thumb-card-xsmall", { :count => 1 }
    end
  end

  def test_show_both
    get :show, :tag => 'b'
    assert_response :success
    assert_template 'tag/show'
    assert_tag_cloud
    assert_select "dl" do
      assert_select "dd", { :count => 2 }
      assert_select "a", { :text => Post.find(1).title }
      assert_select "div.thumb-card-xsmall", { :count => 1 }
    end
  end
  
end
