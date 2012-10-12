require File.dirname(__FILE__) + '/../../test_helper'

class CurrentsTest < Test::Unit::TestCase
  fixtures :manufacturers, :lantern_types, :lanterns
  fixtures :currents

  def setup
    @cu = Current.find(:first)
    @ncu = Current.new
    @ncu.lantern = @cu.lantern
    @ncu.voltage = @cu.voltage+1
    @ncu.current = @cu.current
    @ncu.frequency = @cu.frequency
  end

  def test_unique
    assert @ncu.valid?
    @ncu.voltage = @cu.voltage
    assert !@ncu.save
    @ncu.voltage = @cu.voltage + 1
    assert @ncu.save
    @ncu.voltage = @cu.voltage
    assert !@ncu.save
    @ncu.frequency = @cu.frequency + 1
    assert @ncu.save
  end

  def test_create
    assert @ncu.save
    assert @ncu.id > 0
    assert_equal @cu.lantern, @ncu.lantern
  end

  def test_destroy
    @cu.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Current.find(@cu.id) }
  end

  def test_numericality
    @ncu.current = "10A"
    assert !@ncu.valid?
    @ncu.current = @cu.current
    assert @ncu.valid?
    @ncu.voltage = "230V"
    assert !@ncu.valid?
    @ncu.voltage = 230.5
    assert !@ncu.valid?
    @ncu.voltage = @cu.voltage + 1
    @ncu.frequency = "50Hz"
    assert !@ncu.valid?
    @ncu.frequency = "50.5"
    assert !@ncu.valid?
  end

  def test_ranges
    @ncu.current = 200
    assert !@ncu.valid?
    @ncu.current = @cu.current
    assert @ncu.valid?
    @ncu.frequency = 150
    assert !@ncu.valid?
    @ncu.frequency = 50
    assert @ncu.valid?
    @ncu.voltage = 450
    assert !@ncu.valid?
  end

  def test_cascade_lantern
    @lantern = @cu.lantern
    @lantern.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Current.find(@cu.id) }
  end
end
