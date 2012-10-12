require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_dsl.rb"

# Tests the 'extras' that appear when 'admin' is logged in and viewing normal pages
# Extras are:
#   Red Banner
#   Edit link next to breadcrumbs
#   Admin item in menu

class TestAdminExtrasTest < ActionController::IntegrationTest
  fixtures :comatose_pages

  def test_comatose_no_session
    get '/photos'
    assert_response :success
    assert_select "#bannerhead[class=admin]", false
    assert_select "#menu li > a", :text => 'Admin', :count => 0
    assert_select "#crumbs"
    assert_select "#crumbs a", :text => 'Edit', :count => 0
  end
  
  def test_comatose_with_session
    admin_session do |admin|
      admin.get '/photos'
      admin.assert_response :success
      admin.assert_select "#bannerhead[class=admin]"
      admin.assert_select "#crumbs"
      admin.assert_select "#crumbs > a", :text => 'Edit'
      admin.assert_select "#menu li > a", :text => 'Admin'
    end
  end
  
  private
  
  def admin_session
    open_session do |session|
      session.extend(IntegrationDsl)
      session.login_as_admin
      yield session if block_given?
    end
  end
end
