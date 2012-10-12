require File.dirname(__FILE__) + '/../test_helper'

class TagsTest < Test::Unit::TestCase
  fixtures :posts, :photos
  fixtures :tags, :taggings

  def test_fixtures
    assert_tag_counts Tag.counts, { 'a' => 1, 'b' => 2, 'c' => 1, 'd' => 0 }
  end
  
  def test_add
    assert post = Post.find(3)
    assert post.tag_list = "a, b, e"
    assert post.save
    assert tags = Tag.counts
    assert_tag_counts tags, { 'a' => 2, 'b' => 3, 'e' => 1 }
  end
  
  def test_delete_taggable
    assert Post.find(1).destroy
    assert_tag_counts Tag.counts, { 'a' => 0, 'b' => 1 }
  end
  
  def test_delete_tag
    assert c = Tagging.count
    assert Tag.find_by_name("b").destroy
    assert_equal c - 2, Tagging.count
    assert_equal ["a"], Post.find(1).tag_list
    assert_equal ["c"], Photo.find(1).tag_list
  end
  
  def test_tags_change
    assert photo = Photo.find(1)
    assert photo.tag_list = ['b', 'c']
    assert photo.tag_list = "c, d"
    assert photo.save
    assert_tag_counts Tag.counts, {'a' =>1, 'b' => 1, 'c' => 1, 'd' => 1}
  end
end