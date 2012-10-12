require File.dirname(__FILE__) + '/../test_helper'

class LastfmItemTest < Test::Unit::TestCase
  fixtures :lastfm_items

  def test_destroy_items
    assert_equal 2, LastfmItem.find_all_by_lastfm_chart_id(123).size
    LastfmItem.delete_all(['lastfm_chart_id = ?', 123])
    assert_equal nil, LastfmItem.find_by_lastfm_chart_id(123)
  end
end
