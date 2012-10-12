require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_dsl.rb"

class TestAdminHackerTest < ActionController::IntegrationTest
  fixtures :comatose_pages
  fixtures :photo_sets, :photos, :photos_photo_sets, :tags
  LOCKED_PAGES = ['admin/contacts', 'admin/redirections', 'admin/comatose_admin', 
                  'admin/photos', 'admin/photo_sets', 'admin/tags', 'admin/posts']
  UNLOCKED_PAGES = ['', 'photos', 'lightingdb', 'tags/a', 'blog/2006', 'blog/2004']
  
  def test_admin_login
    admin = new_session do |session|
      session.login_as_admin
    end
    hacker = new_session do |session|
      session.attempts_login("memyself", "asscripes", false)
      session.attempts_login("memyelf", "ar5ecr1sps", false)
    end
    admin.attempts_get('/admin/photos', true)
    LOCKED_PAGES.each do |url|
      admin.attempts_get(url, true)
    end
    UNLOCKED_PAGES.each do |url|
      admin.attempts_get(url, true)
    end
    LOCKED_PAGES.each do |url|
      hacker.attempts_get(url, false)
    end
    google = new_session
    google.attempts_get('/admin/photos', false)
  end

  def test_admin_lockout
    google = new_session
    LOCKED_PAGES.each do |url|
      google.attempts_get(url, false)
    end
    UNLOCKED_PAGES.each do |url|
      google.attempts_get(url, true)
    end
  end

  def test_admin_logout
    new_session do |admin|
      admin.login_as_admin
      admin.attempts_get('admin/contacts')
      admin.get('admin/logout')
      admin.is_redirected_to('admin/admin/login')
      assert admin.session[:user].nil?
      LOCKED_PAGES.each do |url|
        admin.attempts_get(url, false)
      end
      UNLOCKED_PAGES.each do |url|
        admin.attempts_get(url, true)
      end
    end
  end
  
  private
  def new_session
    open_session do |session|
      session.extend(IntegrationDsl)
      yield session if block_given?
    end
  end
end
