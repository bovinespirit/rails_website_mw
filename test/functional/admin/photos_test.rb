require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/photos_controller'

# TODO: Proper testing

# Re-raise errors caught by the controller.
class Admin::PhotosController
  def rescue_action(e)
    raise e
  end
  
# Let ourselves in...
  def authenticate
    true
  end
end

class PhotosControllerTest < Test::Unit::TestCase
  fixtures :photos
  fixtures :comatose_pages, :photo_sets
  fixtures :photos_photo_sets

  def setup
    @controller = Admin::PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
  end
  
  def test_show
    get :show, { :id => 1 }
    assert_response :success
  end 

  def test_new
    get :new
    assert_response :success
    get :new, { :photo_set_id => 4 }
  end

  def test_edit
    get :new, { :id =>1 }
    assert_response :success
  end

  def test_edit_thumbnail
    get :edit_thumbnail, { :id =>1 }
    assert_response :success
  end

end
