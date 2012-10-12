require File.dirname(__FILE__) + '/../../test_helper'

class AdminWebpageTest < Test::Unit::TestCase
  fixtures :comatose_pages
  
  def test_login_webpage
    assert wp = Webpage.create("admin/login")
    assert_equal "/admin/login", wp.uri
    assert_equal "/admin", wp.parent.uri
    assert_equal 0, wp.children.size
    assert_equal 1, wp.parent.children.size
    assert_equal 1, wp.position
    assert_equal false, wp.has_next?
    assert_equal false, wp.has_prev?
    assert_nil wp.next
    assert_nil wp.prev
  end
end