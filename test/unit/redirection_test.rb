require File.dirname(__FILE__) + '/../test_helper'

# Mighty bodge to get file loading to work
class File < IO
  def size
    File.size(self.path)
  end
end

class RedirectionTest < Test::Unit::TestCase
  fixtures :photos, :photo_sets, :comatose_pages
  fixtures :redirections

  def setup
    @test_data_dir = File.dirname(__FILE__) + '/../test_data/'
  end

  def test_redirect_comatose_page
    assert_equal '/photos', Redirection.redirect('/oldphotos')
  end
  
  def test_redirect_index
    assert_equal '', Redirection.redirect('/index')
    assert_equal '', Redirection.redirect('/index.html')
  end
  
  def test_redirect_photo
    assert_equal '/photo/show/3-another-photo', Redirection.redirect('/photos/EasternEurope/Prague1')
  end
  
  def test_redirect_photo_set
    assert_equal '/photos/lots-of-photos', Redirection.redirect('/photos/OtherStuff/Oakley')
  end
  
  def test_nullify_comatose_index
  # Destroying the index also destroys it's children
    ComatosePage.find(1).destroy
    assert re = Redirection.find(1)
    assert_equal nil, re.targetable_id
    assert_equal 3, Redirection.find_all_by_targetable_id(nil).size
    assert_equal 3, Redirection.find_targetless.size
  end
  
  def test_nullify_comatose_photos
    ComatosePage.find(3).destroy
    assert_equal 1, Redirection.find_targetless.size
  end
  
  def test_nullify_photo
    Photo.find(3).destroy()
    assert_equal 1, Redirection.find_targetless.size
  end
  
  def test_nullify_photo_set
    PhotoSet.find(5).destroy()
    assert_equal 1, Redirection.find_targetless.size
  end
  
  def test_not_known
    assert_equal nil, Redirection.redirect("Made_up")
  end
  
  # CSV File reading test
  def test_read_csv_file
    assert oldsize = Redirection.count
    Redirection.read_google_csv(File.open(@test_data_dir + "google_not_found.csv"))
    assert_equal 4, Redirection.count - oldsize
    assert Redirection.find_by_uri("/computing/cvinfo")
    assert Redirection.find_by_uri("/computing/cvinfo.html")
    assert_equal 1, Redirection.find_all_by_uri("/index").size
  end
end
