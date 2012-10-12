require File.dirname(__FILE__) + '/../../test_helper'

class WebpageTest < Test::Unit::TestCase
  fixtures :comatose_pages
  fixtures :photos
  fixtures :photo_sets
  
  def test_create_comatose_webpage
    page = comatose_page(1)
    cp = Webpage.create(page)
    assert_equal cp.title, page.title
    assert_equal cp.uri, page.uri
    assert_equal cp.updated_on, page.updated_on
    assert_equal cp.menu_title, page.menu_title
    assert_equal cp.depth, 0
    assert_equal cp.parent, nil
  end
  
  def test_comatose_webpage_next
    assert page = comatose_page(3)
    assert cp = Webpage.create(page)
    ne = cp.next
    assert_equal ne.menu_title, 'Empty'
    assert_equal ne.next.menu_title, 'Textile Test'
  end
  
  def test_comatose_webpage_prev
    assert page = comatose_page(3)
    assert cp = Webpage.create(page)
    assert pr = cp.prev
    assert_equal pr.menu_title, "Lighting Database"
    assert_equal pr.prev, nil
  end
  
  def test_index_prev
    assert page = comatose_page(1)
    assert wp = Webpage.create(page)
    assert_equal false, wp.has_prev?
  end
  
  def test_comatose_webpage_children
    cp = Webpage.create(comatose_page(3))
    assert_equal cp.menu_title, 'Photos'
    assert_equal 7, cp.children.size
    assert_equal cp.children[1].parent, cp   
  end
  
  def test_comatose_page_index
    cp = Webpage.create(comatose_page(3))
    assert_equal cp.index.menu_title, 'Index'
    assert_equal cp.current?, true 
  end
  
  def test_comatose_page_index_index
    assert cp = Webpage.create(comatose_page(1))
    assert idx = cp.index
    assert_equal cp.uri, idx.uri
  end
  
  def test_comatose_page_section
    assert_equal Webpage.create(comatose_page(3)).section?, true
    assert_equal Webpage.create(comatose_page(6)).section?, false
  end
  
  def test_second_load
    assert wrap1 = comatose_page(1)
    assert wp1 = Webpage.create(wrap1)
    assert 3, wp1.children.size
    assert wp1.index
    assert_equal wp1.title, "Matt West's Homepage"
    assert wrap2 = comatose_page(3)
    assert wp2 = Webpage.create(wrap2)
    assert wp2.index
    assert_equal wp2.title, "Lovely Photos"
    assert wp3 = wp2.children[0]
    assert wp3.index
    assert 'Collection of 2 photos', wp3.title
    assert wp3.menu_title
    assert 2, wp3.children.size
    assert wp4 = wp2.children[1]
    assert wp4.index
    assert 7, wp4.children.size
    assert_equal wp4.index.uri, wp1.uri
    assert_equal 7, wp2.children.size
    assert wrap1 = comatose_page(5)
    assert wp1 = Webpage.create(wrap1)
    assert wp1.index
    assert_equal 7, wp1.children.size
  end
  
  def test_photo_webpage
    assert photo = Photo.find(1)
    assert pp = Webpage.create(photo)
    assert_equal pp.title, photo.title
    assert_equal pp.menu_title, photo.title
    assert_equal pp.updated_on, photo.updated_on
    assert_equal pp.children.size, 0
  end
  
  def test_photo_webpage_next_prev
    assert photo = Photo.find(2)
    assert Webpage.create(photo)
  end
  
  def test_webpage_class_unknown
    assert_raise RuntimeError do
      Webpage.create(["Errorneous", 'Array']) 
    end
  end
  
  def test_admin_page
    assert wp = Webpage.create("admin")
    assert wp.admin?
    assert wp.show_admin
  end
  
  def test_non_admin_page
    assert wp = Webpage.create(comatose_page(3))
    assert !wp.admin?
    assert !wp.show_admin
  end
  
  def test_admin_prevnext
    assert wp = Webpage.create('admin')
    assert wp.has_prev?
    assert !wp.has_next?
  end
  
  def test_class_list
    assert li = Webpage.class_list
    assert li.size > 0
    assert li.include?("ComatosePage")
    assert li.include?("PhotoSet")
    assert !li.include?("admin")
  end
  
  def test_pages_string
    assert li = Webpage.pages("ComatosePage")
    assert li.size > 0
    assert li.include?(["Lighting Database", 2])
  end
  
  def test_pages_nil
    assert li = Webpage.pages(nil)
    assert li.empty?
  end
  
  def test_index_crumbs
    i = 0
    assert idx = Webpage.create(comatose_page(1)).index
    idx.crumbs { |crumb, has_next| i += 1 }
    assert_equal 0, i
  end
  
  def test_photo_crumbs
    ar = []
    assert idx = Webpage.create(comatose_page(5)).index
    idx.crumbs do |crumb, has_next|
      ar << [crumb, has_next]
    end
    assert_equal 2, ar.size
    assert_equal comatose_page(3).title, ar[0][0].title
    assert_equal true, ar[0][1]
    assert_equal comatose_page(5).title, ar[1][0].title
    assert_equal false, ar[1][1]
  end
  
  def test_photo_first
    assert page = ComatosePage.find(5)
    assert wp = Webpage.create(page).children[3]
    assert_equal "Collection of Photos - Photo 7", wp.first.title
  end
  
  def test_photo_last
    assert page = ComatosePage.find(5)
    assert wp = Webpage.create(page).children[3]
    assert_equal "Collection of Photos - Photo 1", wp.last.title
  end
  
  protected
  # Find comatose page by ID, then wrap it up in a Comatose::PageWrapper
  def comatose_page(id)
    assert page = ComatosePage.find(id)
    assert wrap = Comatose::PageWrapper.new(page)
    return wrap
  end
end