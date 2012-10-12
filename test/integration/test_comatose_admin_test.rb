require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_dsl.rb"

class TestComatoseAdminTest < ActionController::IntegrationTest
  fixtures :comatose_pages
  fixtures :comatose_page_versions

  def setup
    @admin = open_session do |session|
      session.extend(IntegrationDsl)
      session.login_as_admin
    end
  end
  
  def test_edit_page
    @admin.attempts_get('admin/comatose_admin/edit/1')
    # Check that my extra bits are present in the comatose_admin/_form file
    @admin.assert_select "tr#menu_title_row"
    @admin.assert_select "tr#photo_set_row"
  end
  
  def test_new_page
    @admin.attempts_get('admin/comatose_admin/new?parent=1')
  end
  
  def test_versions
    @admin.attempts_get('admin/comatose_admin/versions/1')
  end
  
  def test_no_staging
    get '/new-page'
    assert_response 404
    @admin.attempts_get('/new-page', true)
  end
  
  def test_create_photo_set
    assert page = ComatosePage.find_by_id(6)
    assert_nil PhotoSet.find_by_obj(page)
    @admin.get "admin/comatose_admin/createphotoset/#{page[:id]}"
    @admin.assert_equal "Photo set created", @admin.flash[:notice]
    @admin.assert_redirected_to :action => :edit, :id => page[:id]
    assert PhotoSet.find_by_obj(page)
  end
end