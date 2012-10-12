require File.dirname(__FILE__) + '/../test_helper'
require 'comatose_controller'
require 'comatose/processing_context'

# Re-raise errors caught by the controller.
class ComatoseController; def rescue_action(e) raise e end; end

class ComatoseTest < Test::Unit::TestCase
  fixtures :comatose_pages

  def setup
    @controller = ComatoseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_is_valid
    get :show, :page => '', :index => ''
    assert_has_xml_prolog
    assert_doctype(:xhtml_10_strict)
    assert_compatible_empty_elements
    assert_no_empty_attributes
    assert_no_long_style_attributes
#    assert_content_type
#    assert_valid_xhtml   
  end
  
  def test_photo_page_valid
    get :show, :page => 'photos/lots-of-photos', :index => ''
    assert_has_xml_prolog
    assert_doctype(:xhtml_10_strict)
    assert_compatible_empty_elements
    assert_no_empty_attributes
    assert_no_long_style_attributes
#    assert_valid_xhtml   
  end

  def test_404
    get :show, :page => 'unreal_page', :index => ''
    assert_response :missing
    assert_select 'h1', :text => /Not Found/
    assert_select 'head > title', :text => /404/    
  end

  def test_404_valid
    get :show, :page => 'unreal_page', :index => ''
    assert_has_xml_prolog
    assert_doctype(:xhtml_10_strict)
    assert_compatible_empty_elements
    assert_no_empty_attributes
    assert_no_long_style_attributes
#    assert_valid_xhtml   
  end
end
