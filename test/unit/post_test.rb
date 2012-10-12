require File.dirname(__FILE__) + '/../test_helper'

class PostTest < Test::Unit::TestCase
  fixtures :posts

  def test_new_post_created_at
    assert post = Post.new(:body => "Test body", :title => 'Test title')
    assert t = 1.year.ago.to_time
    assert post.created_at = t
    assert post.valid?
    assert post.save
    assert po = Post.find_by_title('Test title')
    assert_equal t.to_formatted_s(:long), po.created_at.to_formatted_s(:long)
  end
  
  def test_date_year_only
    assert c = Post.count_by_date_and_id({:year => 2006}, true)
    assert_equal 6, c
  end

  def test_date_year_month
    assert c = Post.count_by_date_and_id({:year => 2006, :month => 3}, true)
    assert_equal 4, c
  end
  
  def test_date_year_month_day
    assert c = Post.count_by_date_and_id({:year => 2006, :month => 3, :day => 10}, true)
    assert_equal 2, c
  end

  def test_date_year_month_day_id
    assert posts = Post.find_by_date_and_id({:year => 2006, :month => 3, :day => 10, :id => 1}, true)
    assert_equal 1, posts.size
    assert_equal 1, posts.first.id
  end
  
  def test_date_year_without_staging
    assert c = Post.count_by_date_and_id({:year => 2006})
    assert_equal 4, c
  end
  
  def test_date_no_limits
    assert c = Post.count_by_date_and_id({}, true)
    assert_equal 8, c
  end
  
  def test_guid
    assert post = Post.find(:first)
    assert post.guid =~ /matthewwest.co.uk/
    assert post.guid =~ /#{post.id}/
  end
end
