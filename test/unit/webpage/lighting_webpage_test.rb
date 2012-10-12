require File.dirname(__FILE__) + '/../../test_helper'

class LightingWebpageTest < Test::Unit::TestCase
  fixtures :comatose_pages
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :gobo_sizes, :gobos, :gobo_wheel_types
  fixtures :gobo_wheels, :gobo_wheels_lanterns, :gobo_wheels_gobos
  fixtures :error_messages, :error_messages_lanterns

  def test_lightingdb_index
    assert wp = Webpage.from('lightingdb')
    assert_equal wp.index.menu_title, 'Index'
    assert_equal wp.parent.menu_title, 'Index'
    assert_equal wp.title, 'Lighting Database'
    assert_equal wp.menu_title, 'Lighting Database'
    assert_equal 3, wp.children.size
    assert wp.section?
  end
  
  def test_lightingdb_override
    assert page = ComatosePage.find_by_slug('lightingdb')
    assert wrap = Comatose::PageWrapper.new(page)
    assert wp = Webpage.from(wrap)
    assert_equal true, wp.section?
    assert_equal 3, wp.children.size
  end
  
  def test_manufacturer_page
    assert man = Manufacturer.find(1)
    assert wp = Webpage.from(man)
    assert_equal wp.title, man.name
    assert_equal 'Lighting Database', wp.parent.title
    assert_equal man.lanterns.count, wp.children.size
    assert wp.section?
  end
  
  def test_lantern_page
    assert lan = Lantern.find(1)
    assert wp = Webpage.from(lan)
    assert_equal wp.title, lan.name
    assert_equal lan.manufacturer.name, wp.parent.title
    assert_equal 2, wp.children.size
    assert wp.section?
  end
  
  def test_gobo_page
    assert lan = Lantern.find(1)
    assert wp = Webpage.from({:object => 'lightingdb/showgobos', :lantern => lan})
    assert_equal "#{lan.name} - Gobos", wp.title
    assert_equal 'Gobos', wp.menu_title
    assert_equal lan.name, wp.parent.title
    assert wp.children.empty?
  end
  
  def test_errors_page
    assert lan = Lantern.find(1)
    assert wp = Webpage.from({:object => 'lightingdb/showerrors', :lantern => lan})
    assert_equal "#{lan.name} - Errors", wp.title
    assert_equal 'Errors', wp.menu_title
    assert_equal lan.name, wp.parent.title
    assert lan.error_messages.count, wp.children.size
  end
  
  def test_error_page
    assert lan = Lantern.find(1)
    assert err = ErrorMessage.find(1)
    assert wp = Webpage.from({:object => err, :lantern => lan})
    assert_equal err.error, wp.menu_title
    assert_equal 'Errors', wp.parent.menu_title
    assert_equal 0, wp.children.size
  end
  
end