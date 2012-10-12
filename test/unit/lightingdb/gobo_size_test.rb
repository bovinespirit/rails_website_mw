require File.dirname(__FILE__) + '/../../test_helper'

class GoboSizeTest < Test::Unit::TestCase
  fixtures :gobo_sizes

  def setup
    @gs = GoboSize.find(gobo_sizes('gobo_size_mac500').id)
    @ngs = GoboSize.new
    @ngs.name = "ab-cd"
  end

  def test_name
    abcd_tests @ngs, "name", " -", 255
    @ngs.name = "R"
    assert @ngs.valid?
    @ngs.name = ""
    assert !@ngs.valid?
  end
   
  def test_unique
    @ngs.name = @gs.name
    assert !@ngs.save
  end

  def test_destroy
    @gs.destroy
    assert_raise(ActiveRecord::RecordNotFound) { GoboSize.find(@gs.id) }
  end
end
