require File.dirname(__FILE__) + '/../test_helper'
require 'website_controller'

# Re-raise errors caught by the controller.
class WebsiteController; def rescue_action(e) raise e end; end

class WebsiteControllerTest < Test::Unit::TestCase
  fixtures :comatose_pages

  def setup
    @controller = WebsiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_sitemap
    get :sitemap, :format => :xml
    assert_response :success
    assert_match %r{application\/xml}, @response.content_type
    assert_select 'urlset'
    assert_select 'urlset > url'
  end
end
