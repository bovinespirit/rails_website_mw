require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_dsl.rb"

class WebsiteWorksTest < ActionController::IntegrationTest
  fixtures :comatose_pages, :posts, :contacts
  fixtures :photo_sets, :photos, :photos_photo_sets
  fixtures :tags, :taggings
  fixtures :manufacturers, :lantern_types, :lanterns

  def test_comatose
    attempts_get ''
    attempts_get 'empty'
    attempts_get 'photos/duo-photo-page'
  end
  
  def test_textile_in_comatose
    attempts_get 'textile-test'
    assert_select('h6', false, "<notextile> not working properly.")
  end
  
  def test_textile_in_captioned_photo
    attempts_get 'textile-test'
    assert_select('div#testdiv > ul') do |elements|
      elements.each do |element|
        assert_select element, "li", :text => /Item?/
      end
    end
    assert_select('a.caption > div > ul') do |elements|
      elements.each do |element|
        assert_select(element, 'li')
      end
    end
  end
  
  def test_photos
    attempts_get 'photo/show/1'
    assert_select('h1', Photo.find(1).title)
    attempts_get 'photo/set/3/1'
    assert_select('h1', "#{PhotoSet.find(3).title} - #{Photo.find(1).title}")
    attempts_get 'photo/set/3-asdf/1-asdf'
    assert_select('h1', "#{PhotoSet.find(3).title} - #{Photo.find(1).title}")
  end
  
  def test_blog_year
    attempts_get 'blog'
    attempts_get 'blog/2004'
    assert_select 'h1', "Blog - 2004"
    assert_select 'h3', "I did not post anything in 2004."
    attempts_get 'blog/2005'
    assert_select 'div.post', :count => 1
    assert_select 'h2 > a', "six"
  end
  
  def test_blog_post
    attempts_get 'blog/2007/1/1/7-seven'
    assert_select 'h2', "seven"
  end

  def test_tags
    attempts_get 'tags/a'
    assert_select 'h1', "Tag - a"
  end

  def test_lightingdb
    attempts_get 'lightingdb'
    attempts_get 'lightingdb/showmanufacturer/Martin'
    attempts_get 'lightingdb/showlantern/Martin/Mac 500'  
  end
  
  def test_sitemap
    attempts_get 'sitemap.xml'
  end
  
  def test_feeds
    attempts_get 'blog/feeds.atom'
    attempts_get 'blog/feeds.rss'
  end

  private
  def attempts_get(url)
    get url
    assert_response :success
    assert_nil session[:user]
  end
end