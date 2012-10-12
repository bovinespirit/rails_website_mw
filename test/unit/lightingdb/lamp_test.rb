require File.dirname(__FILE__) + '/../../test_helper'

class LampTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :lamps, :lamps_lanterns

  def setup
    @lmp = Lamp.find(lamps('msr575_lamp').id)
    @lan = lanterns('mac500_lantern')
    @nlmp = Lamp.new
    @nlmp.name = "New Lamp"
    @nlmp.power = @lmp.power
    @nlmp.life = @lmp.life
    @nlmp.temp = @lmp.temp
    @nlmp.manufacturer = @lmp.manufacturer
  end

  def test_new
    assert @nlmp.save
  end

  def test_name
    abcd_tests @nlmp, "name", " /-", 255
    @nlmp.name = ""
    assert !@nlmp.valid?
    @nlmp.name = @lmp.name
    assert !@nlmp.valid?
  end

  def test_power
    assert @nlmp.valid?
    @nlmp.power = 10001
    assert !@nlmp.valid?
  end

  def test_temp
    @nlmp.temp = nil
    assert @nlmp.valid?
    @nlmp.temp = 99
    assert !@nlmp.valid?
    @nlmp.temp = 10001
    assert !@nlmp.valid?
  end

  def test_life
    @nlmp.life = nil
    assert @nlmp.valid?
    @nlmp.life = 9
    assert !@nlmp.valid?
    @nlmp.life = 100001
    assert !@nlmp.valid?
  end

  def test_joins
    lmps = lanterns('mac600_lantern').lamps
    assert_equal lmps.length, 1
    assert_equal lmps.first.name, lamps('msr575_lamp').name
    lmps = lanterns('mac500_lantern').lamps
    assert_equal lmps.length, 2
    lans = @lmp.lanterns
    assert_equal lans.length, 2
  end

  def test_destroy
    @lmp.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Lamp.find(@lmp.id) }
    assert Lantern.find(@lan.id)
    assert Manufacturer.find(@lmp.manufacturer_id)
  end

  def test_cascade_lantern
    cascade_tests(Lantern, Lamp, :a => @lan, :b => @lmp)
  end

  def test_cascade_lamp
    cascade_tests(Lamp, Lantern, :a => @lmp, :b => @lan)
  end

end
