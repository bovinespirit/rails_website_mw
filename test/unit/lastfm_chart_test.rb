require File.dirname(__FILE__) + '/../test_helper'

class LastfmChartTest < Test::Unit::TestCase
  fixtures :lastfm_items
  fixtures :lastfm_charts

  def test_overall
    assert chart = LastfmChart.get_overall()
    assert_equal 10, chart.items.count
    assert chart.from
  end

  def test_recent_weekly_reload
    assert chart = LastfmChart.get_recent_weekly()
    assert chart.from
    assert chart2 = LastfmChart.get_recent_weekly()
    assert_equal chart.from, chart2.from
    assert_equal chart.items[1], chart2.items[1]    
  end
end
