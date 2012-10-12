require File.dirname(__FILE__) + '/../test_helper'
require 'post_controller'

# Re-raise errors caught by the controller.
class PostController; def rescue_action(e) raise e end; end

class PostControllerTest < Test::Unit::TestCase
  fixtures :posts
  fixtures :tags, :taggings
  
  def setup
    @controller = PostController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_date_empty
    get :date, { :year => 1985 }, {:user => true}
    assert_response :success
    assert_template 'post/index'
    assert_select "h3", :count => 1

    assert_compatible_empty_elements
    assert_no_empty_attributes
#    assert_valid_xhtml
  end
  
  def test_index
    get :date, {}, { :user => true }
    assert_response :success
    assert_template 'post/index'

    assert_compatible_empty_elements
    assert_no_empty_attributes
#    assert_valid_xhtml
  end
  
  # Same page as used in test_date_2006_3_10_1
  def test_tags
    get :date, { :year => 2006, :month => 3, :day => 10, :id => 1 }, { :user => true }
    assert_response :success
    
    assert_select "h4.tags", { :count => 1 }, "Could not find tags section" do
      post = Post.find(1)
      post.tags.each do |tag|
        assert_select %Q|a[href="#{tag_page_url(:tag => tag.name)}"]|, {:count => 1}, "Tag: #{tag.name} should appear once"
      end 
    end
    
    assert_tag_cloud
    
  end
  
  def test_date_2006_3
    get :date, {:year => 2006, :month => 3}, { :user => true }
    assert_response :success
    assert_template 'post/index'
    
    assert_select "h2", :count => 4
    assert_select "h4.datetime", :count => 4
    assert_select 'p', { :text => /Fin/, :count => 1 }
  end
  
  def test_date_2006_3_10_1
    get :date, {:year => 2006, :month => 3, :day => 10, :id => 1}, { :user => true }
    assert_response :success
    assert_template 'post/show'
    
    assert_select 'p', /Fin/

    assert_compatible_empty_elements
    assert_no_empty_attributes
#    assert_valid_xhtml
  end   
end
