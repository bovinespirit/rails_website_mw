require File.dirname(__FILE__) + '/../../test_helper'

class GoboWheelTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :gobo_sizes, :gobos, :gobo_wheel_types
  fixtures :gobo_wheels, :gobo_wheels_lanterns, :gobo_wheels_gobos

  def setup
    @gw = GoboWheel.find(gobo_wheels('mac5_fixed_wheel').id)
    @ngw = GoboWheel.new { |g|
      g.quantity = 5
      g.gobo_wheel_type = gobo_wheel_types('fixed_wheel')
      g.gobo_size = gobo_sizes('gobo_size_golden_scan')
      g.comment = "New Comment"
    }
  end

  def test_create
    assert @ngw.save
  end

  def test_comment
    abcd_tests @ngw, "comment", " ,.:;()-", 0, ")."
    @ngw.comment = ""
    assert @ngw.valid?
  end

  def test_destroy
    lan = @gw.lanterns.first
    gobo = @gw.gobos.first
    @gw.destroy
    assert_raise(ActiveRecord::RecordNotFound) { GoboWheel.find(@gw.id) }
    assert_equal GoboWheelsGobo.find(:first, :conditions => ["gobo_wheel_id = ?", @gw.id]), nil
    assert GoboSize.find(@gw.gobo_size_id)
    assert GoboWheelType.find(@gw.gobo_wheel_type_id)
    assert Lantern.find(lan.id)
    assert Gobo.find(gobo.id)
  end

  def test_cascade_lantern
    cascade_tests Lantern, GoboWheel, :a => lanterns('mac500_lantern'), :b => gobo_wheels('mac5_fixed_wheel')
  end

  def test_cascade_gw_lantern
    cascade_tests GoboWheel, Lantern, :a => gobo_wheels('mac5_rotating_wheel'), :b => lanterns('pro918_lantern')
  end

  def test_cascade_gobo
    cascade_tests Gobo, GoboWheel, :a => gobos('triangle_gobo'), :b => gobo_wheels('mac5_rotating_wheel')
  end

  def test_cascade_gw_gobo
    cascade_tests GoboWheel, Gobo, :a => gobo_wheels('mac5_rotating_wheel'), :b => gobos('triangle_gobo')
  end

  def test_get_position
    g = @gw.gobo(1)
    assert_kind_of Gobo, g
    assert_equal g.description, gobos('circle_gobo').description
    assert !@gw.gobo(5)
    assert_raise(ActiveRecord::RecordNotFound) { @gw.gobo(10) }
    assert_raise(ActiveRecord::RecordNotFound) { @gw.gobo(0) }
    assert_equal gobo_wheels('mac5_rotating_wheel').gobo(1).description, gobos('triangle_gobo').description
  end

  def test_add_gobo
    c = @gw.gobos.size
    @gw.set_gobo(4, gobos('circle_gobo'))
    @gw.reload
    assert_equal c, @gw.gobos.size - 1
    assert_equal @gw.gobo(4).description, gobos('circle_gobo').description
  end

  def test_set_gobo
    c = @gw.gobos.size
    @gw.set_gobo(1, gobos('triangle_gobo'))
    assert_equal c, @gw.gobos.size
    assert_equal @gw.gobo(1).description, gobos('triangle_gobo').description
    assert_raise(ActiveRecord::RecordNotFound) { @gw.set_gobo(@gw.quantity + 1, gobos('circle_gobo')) }
    assert_raise(ActiveRecord::RecordNotFound) { @gw.set_gobo(0, gobos('circle_gobo')) }
  end

  def test_destroy_gobo
    c = @gw.gobos.size
    @gw.destroy_gobo(2)
    @gw.reload
    assert_equal c, @gw.gobos.size + 1
  end    
end
