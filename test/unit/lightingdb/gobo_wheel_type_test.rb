require File.dirname(__FILE__) + '/../../test_helper'

class GoboWheelTypeTest < Test::Unit::TestCase
  fixtures :gobo_wheel_types

  def setup
    @gw = GoboWheelType.find(1)
    @ngw = GoboWheelType.new
    @ngw.name = "New Wheel"
  end

  def test_ngw
    assert @ngw.valid?
    assert @ngw.save
    assert @ngw.id != @gw.id
  end

  def test_destroy
    @gw.destroy
    assert_raise(ActiveRecord::RecordNotFound) { GoboWheelType.find(@gw.id) }
  end

  def test_name_valid
    abcd_tests @ngw, "name", " ", 255
  end

  def test_unique
    assert @ngw.valid?
    @ngw.name = @gw.name
    assert !@ngw.valid?
  end
end
