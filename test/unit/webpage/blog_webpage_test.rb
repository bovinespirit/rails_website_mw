require File.dirname(__FILE__) + '/../../test_helper'

class BlogWebpageTest < Test::Unit::TestCase
  fixtures :posts
  
  def test_index_weekly_changefreq
    assert wp = Webpage.create("blog")
    assert_equal 'weekly', wp.changefreq
    assert wp = Webpage.create({:object => "blog", :year => Time.now.year, 
                                                :month => Time.now.month})
    assert_equal 'weekly', wp.changefreq
  end
  
  def test_index_yearly_change_freq
    t = 2.years.ago
    assert wp = Webpage.create({:object => "blog", :year => t.year, 
                                                :month => t.month})
    assert_equal 'yearly', wp.changefreq
  end
end
