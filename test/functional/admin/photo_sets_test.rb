require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/photo_sets_controller'

# Re-raise errors caught by the controller.
class Admin::PhotoSetsController
  def rescue_action(e)
    raise e
  end
  
# Let ourselves in...
  def authenticate
    true
  end
end

class PhotoSetsControllerTest < Test::Unit::TestCase
  fixtures :photos
  fixtures :comatose_pages, :photo_sets
  fixtures :photos_photo_sets

  def setup
    @controller = Admin::PhotoSetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_edit
    get :edit, { :id => 4 }
    assert_response :success
  end
  
  def test_new
    get :new
    assert_response :success
  end
  
  def test_index
    get :index
    assert_response :success
  end
  
  def test_show
    get :show, { :id => 4 }
    assert_response :success
  end
end