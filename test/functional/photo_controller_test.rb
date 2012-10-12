require File.dirname(__FILE__) + '/../test_helper'
require 'photo_controller'

# Re-raise errors caught by the controller.
class PhotoController; def rescue_action(e) raise e end; end

class PhotoControllerTest < Test::Unit::TestCase
  fixtures :photos
  fixtures :comatose_pages, :photo_sets
  fixtures :photos_photo_sets

  def setup
    @controller = PhotoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_single_photo_thorough
    photo_set = photo_sets('lonely_photo_set')
    photo = photos('lonely_photo')
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    assert_template 'photo/set'
    
    # Test titles
    assert long_title = "#{photo_set.title} - #{photo.title}"
    assert_select 'html:root>head' do
      assert_select 'title', { :text => long_title, :count => 1 }
      assert_select %Q|meta[name="title"][content="#{long_title}"]:empty|, :count => 1
      assert_select 'link[rel="next"]:empty', false
      assert_select 'link[rel="prev"]:empty', false
    end
    assert_select 'h1', { :text => long_title, :count => 1 }
    assert_select 'h1', 1
    
    assert_select '#crumbs' do
      assert_select 'a', { :text => photo_set.title, :count => 1 }
      assert_select 'a', { :text => photo.title, :count => 1 }
    end
    
    # Photo
    assert_select 'div.photo' do
      assert_select %Q|img[alt="#{photo.title}"][title="#{photo.title}"]:empty|, :count => 1
      assert_select %Q|img[height="#{photo.height}"][width="#{photo.width}"]:empty|, :count => 1
    end
    
    assert_select 'div.description', :text => 'Lonely testing description'
    assert_select 'div.text', :text => 'Lonely testing text'    
  end
  
  def test_one_of_many_photo_links
    photo_set = photo_sets('big_photo_set')
    photo = photo_set.photos[3]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    assert_template 'photo/set'
    
    # Test titles
    assert long_title = "#{photo_set.title} - #{photo.title}"
    assert_select 'html:root>head' do
      assert_select 'title', { :text => long_title, :count => 1 }
      assert_select %Q|meta[name="title"][content="#{long_title}"]:empty|, 1
      
   # Test prev and next links
      next_title = "#{photo_set.title} - #{photo.next(photo_set).title}"
      assert_select %Q|link[rel="next"][title="#{next_title}"]:empty|, 1
      prev_title = "#{photo_set.title} - #{photo.prev(photo_set).title}"     
      assert_select %Q|link[rel="prev"][title="#{prev_title}"]:empty|, 1
    end
    assert_select 'h1', :text => long_title, :count => 1
    assert_select '#crumbs' do
      assert_select 'a', { :text => photo_set.title, :count => 1 }
      assert_select 'a', { :text => photo.title, :count => 1 }
    end
  end

#
### Photo set page html tests
#

  def test_show_single_photo
    photo_set = photo_sets('lonely_photo_set')
    photo = photos('lonely_photo')
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    
    assert long_title = "#{photo_set.title} - #{photo.title}"
    assert_select 'h1', long_title

    assert_select "li.thumbs", false
    assert_select "#thumbnav", false
  end
  
  def test_show_first_from_collection_of_two
    photo_set = photo_sets('duo_photo_set')
    photo = photos('first_duo_photo')
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success

    assert long_title = "#{photo_set.title} - #{photo.title}"
    assert_select 'h1', long_title

    assert_select 'li.thumbs' do
      assert_select "a#thumb_7"
      assert_select "div#thumbnav" do
        assert_select "div.on", { :text => /more/, :count => 0 }
        assert_select "div.prev", { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select "div.next", { :text => /more/, :count => 1 }
      end
    end
  end

  def test_show_second_from_collection_of_two
    photo_set = photo_sets('duo_photo_set')
    photo = photos('second_duo_photo')
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success

    assert long_title = "#{photo_set.title} - #{photo.title}"
    assert_select 'h1', long_title

    assert_select 'li.thumbs' do
      assert_select "a#thumb_6"
      assert_select "div#thumbnav" do
        assert_select "div.on", { :text => /more/, :count => 0 }
        assert_select "div.prev", { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select "div.next", { :text => /more/, :count => 1 }
      end
    end
  end

  def test_show_first_from_collection_of_four
    photo_set = photo_sets('quad_photo_set')
    photo = photo_set.photos[0]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    
    assert_select 'h1', /Lloyds Tour/

    assert_select 'li.thumbs' do
      assert_thumbbox('2', '3')
      assert_select "#thumbnav" do
        assert_select 'div.on', :count => 1
        assert_select 'div.prev', { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select 'div[class="on next"]', true
      end
    end
  end
  
  def test_show_second_from_collection_of_four
    photo_set = photo_sets('quad_photo_set')
    photo = photo_set.photos[1]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    assert_select 'h1', /Disco/

    assert_select 'li.thumbs' do
      assert_thumbbox('1', '3')
      assert_select "#thumbnav" do
        assert_select 'div.on', 1
        assert_select 'div.prev', { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select 'div[class="on next"]', { :text => /more/, :count => 1 }
      end
    end
  end
  
  def test_show_third_from_collection_of_four
    photo_set = photo_sets('quad_photo_set')
    photo = photo_set.photos[2]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    assert_select 'h1', /Another Photo/

    assert_select 'li.thumbs' do
      assert_thumbbox('2', '4')
      assert_select "#thumbnav" do
        assert_select 'div.on', 1
        assert_select 'div[class="on prev"]', { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select 'div.next', { :text => /more/, :count => 1 }
      end
    end
  end

  def test_show_fourth_from_collection_of_four
    photo_set = photo_sets('quad_photo_set')
    photo = photo_set.photos[3]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    assert_select 'h1', /Last Photo/

    assert_select 'li.thumbs' do
      assert_thumbbox('2', '3')
      assert_select "#thumbnav" do
        assert_select 'div.on', 1
        assert_select 'div[class="on prev"]', { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select 'div.next', { :text => /more/, :count => 1 }
      end
    end
  end
  
  def test_show_middle_of_large_collection
    photo_set = photo_sets('big_photo_set')
    photo = photo_set.photos[3]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success
    assert_select 'h1', /Photo 4/

    assert_select 'li.thumbs' do
      assert_thumbbox('105', '103')
      assert_select "#thumbnav" do
        assert_select 'div.on', 2
        assert_select 'div.prev', { :text => /more/, :count => 1 }
        assert_select 'a.ce', { :text => photo_set.title, :count => 1 }
        assert_select 'div.next', { :text => /more/, :count => 1 }
      end
    end
  end
  
  def test_set_valid
    photo_set = photo_sets('big_photo_set')
    photo = photo_set.photos[3]
    get :set, { :photo_set => photo_set, :photo => photo }
    assert_response :success

    assert_has_xml_prolog
    assert_doctype(:xhtml_10_strict)
    assert_compatible_empty_elements
    assert_no_empty_attributes
#    assert_valid_xhtml
  end
  
#
### Photo carousel rjs tests
#
 
  # 105, 103
  # 103, 102
  def test_ajax_next
    photo_set = photo_sets('big_photo_set')
    photo = photo_set.photos[3]
    xhr :get, :carousel, {:dir => 'next.js', :photo_set => photo_set, :current => photo, :photo => '105'}
    assert_select_rjs :insert_html, :after, 'thumb_103', /thumb_102/
    assert_select_rjs :remove, 'thumb_105'
    assert_select_rjs :replace_html, 'thumbnav', /prev\.js/
    assert_select_rjs :replace_html, 'thumbnav', /next\.js/
  end
  
  # 105, 103
  # 106, 105
  def test_ajax_prev
    photo_set = photo_sets('big_photo_set')
    photo = photo_set.photos[3]
    xhr :get, :carousel, {:dir => 'prev.js', :photo_set => photo_set, :current => photo, :photo => '105'}
    assert_select_rjs :insert_html, :before, 'thumb_105', /thumb_106/
    assert_select_rjs :remove, 'thumb_103'
    assert_select_rjs :replace_html, 'thumbnav', /prev\.js/
    assert_select_rjs :replace_html, 'thumbnav', /next\.js/
  end
  
  def test_ajax_errors
    photo_set = photo_sets('big_photo_set')
    photo = photo_set.photos[3]
    xhr :get, :carousel, { :dir => 'prev.js', :photo => '105', :current => photo }
    assert_response :not_found
    xhr :get, :carousel, { :dir => 'prev.js', :photo_set => photo_set, :current => photo }
    assert_response :not_found
    xhr :get, :carousel, { :dir => 'prev.js', :photo_set => photo_set, :photo => '105' }
    assert_response :not_found
    get :carousel, {:dir => 'next.js', :photo_set => photo_set, :current => photo, :photo => '105'}
    assert_response :not_found
  end
    
end