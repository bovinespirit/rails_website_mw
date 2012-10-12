require File.dirname(__FILE__) + '/../test_helper'
require 'email_controller'
# TODO Proper email functional tests

# Re-raise errors caught by the controller.
class EmailController; def rescue_action(e) raise e end; end

class EmailControllerTest < Test::Unit::TestCase
  def setup
    @controller = EmailController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_valid
    get :send_email
    assert_response :success

    assert_has_xml_prolog
    assert_doctype(:xhtml_10_strict)
    assert_compatible_empty_elements
    assert_no_empty_attributes
#    assert_valid_xhtml
  end
end
