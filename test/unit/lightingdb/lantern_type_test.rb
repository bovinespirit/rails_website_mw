require File.dirname(__FILE__) + '/../../test_helper'

class LanternTypeTest < Test::Unit::TestCase
  fixtures :lantern_types

  def setup
    @lt = LanternType.find(lantern_types('moving_head').id)
    @nlt = LanternType.new
    @nlt.name = "New Lantern Type"
  end

  def test_type
    assert_kind_of LanternType, @lt
  end

  def test_unique_name
    assert @nlt.valid?
    @nlt.name = @lt.name
    assert !@nlt.valid?
  end

  def test_name_format
    abcd_tests @nlt, "name", " ", 255
    @nlt.name = ""
    assert !@nlt.valid?
  end

  def test_destroy
    @lt.destroy
    assert_raise(ActiveRecord::RecordNotFound) { LanternType.find(@lt.id) }
  end
end
