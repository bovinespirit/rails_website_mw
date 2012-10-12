require File.dirname(__FILE__) + '/../../test_helper'

class StagingWebpageTest < Test::Unit::TestCase
  fixtures :comatose_pages
  
  def test_staging
    page = comatose_page(8)
    cp = Webpage.create(page)
    assert cp.staging?
  end
  
  def test_nil_staging
    page = comatose_page(1)
    cp = Webpage.create(page)
    assert !cp.staging?
  end

  def test_staging_children
    assert stage = comatose_page(8)
    assert page = comatose_page(1)
    assert cp = Webpage.create(page)
    cp.show_admin = true
    assert cp.children.collect { |ch| ch.title }.include?(stage.title)
  end

  def test_no_staging_children
    assert stage = comatose_page(8)
    assert page = comatose_page(1)
    assert cp = Webpage.create(page)
    assert !cp.children.collect { |ch| ch.title }.include?(stage.title)
  end

  protected
  # Find comatose page by ID, then wrap it up in a Comatose::PageWrapper
  def comatose_page(id)
    assert page = ComatosePage.find(id)
    assert wrap = Comatose::PageWrapper.new(page)
    return wrap
  end

end