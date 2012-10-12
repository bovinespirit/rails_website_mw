require File.dirname(__FILE__) + '/../../test_helper'

# TODO Add optional_str test
# TODO Add zoom? test

class BeamAngleTest < Test::Unit::TestCase
  fixtures :manufacturers, :lantern_types, :lanterns
  fixtures :beam_angles

  def setup
    @ba = BeamAngle.find(beam_angles('mac500_optional_lens').id)
    @nba = BeamAngle.new()
    @nba.optional = @ba.optional
    @nba.minangle = @ba.minangle
    @nba.maxangle = @ba.maxangle
    @nba.lantern = @ba.lantern
  end

  def test_create
    assert_kind_of BeamAngle, @ba
    assert_equal @ba.optional, beam_angles('mac500_optional_lens').optional
    assert_equal @ba.minangle, beam_angles('mac500_optional_lens').minangle
    assert_equal @ba.maxangle, beam_angles('mac500_optional_lens').maxangle
  end

  def test_save
    @nba.minangle = @ba.minangle - 1
    assert @nba.save
    tba = BeamAngle.find(@nba.id)
    assert_equal tba.optional, @nba.optional
    assert_equal tba.minangle, @nba.minangle
    assert_equal tba.maxangle, @nba.maxangle
    assert_equal tba.lantern, @nba.lantern
    lba = BeamAngle.find_all_by_lantern_id(@nba.lantern.id)
    assert_equal lba.length, 3
  end

  def test_update
    @nba.minangle = @ba.minangle - 1
    assert @nba.save
    tba = BeamAngle.find(@nba.id)
    tba.lantern = lanterns('mac2000_lantern')
    tba.save
    lba = BeamAngle.find_all_by_lantern_id(@nba.lantern.id)
    assert_equal lba.length, 2
    lba = BeamAngle.find_all_by_lantern_id(lanterns('mac2000_lantern').id)
    assert_equal lba.length, 2
  end

  def test_destroy
    @ba.destroy
    assert_raise(ActiveRecord::RecordNotFound) { BeamAngle.find(@ba.id) }
    lba = BeamAngle.find_all_by_lantern_id(@nba.lantern.id)
    assert_equal lba.length, 1
  end

  def test_angle_numbers
    assert @ba.valid?
    @ba.minangle = "hello"
    assert !@ba.valid?
    @ba.minangle = beam_angles('mac500_optional_lens').minangle
    @ba.maxangle = "wrong"
    assert !@ba.valid?
  end

  def test_angle_ranges
    assert @ba.valid?
    @ba.minangle = 0
    assert !@ba.valid?
    @ba.minangle = 180.1
    assert !@ba.valid?
    @ba.minangle = beam_angles('mac500_optional_lens').minangle
    @ba.maxangle = 181
    assert !@ba.valid?
  end

  def test_angle_validate
    assert @ba.valid?
    @ba.minangle = @ba.maxangle + 1
    assert !@ba.valid?
    @ba.minangle = beam_angles('mac500_optional_lens').minangle
    assert @ba.valid?
    assert !@nba.save
    @nba.minangle = @ba.minangle - 1
    assert @nba.save
    @nba.minangle = @ba.minangle
    assert !@nba.valid?
    tba = BeamAngle.find(@nba.id)
    assert_equal tba.minangle, @ba.minangle - 1
    assert_equal tba.maxangle, @nba.maxangle
  end

  def test_optional
    @nba.lantern = lanterns('mac2000_lantern')
    @nba.optional = 1
    assert @nba.valid?
    @nba.optional = 2
    assert !@nba.valid?
    @nba.optional = "pies"
    assert !@nba.valid?
    @nba.optional = true
    assert @nba.save
    tba = BeamAngle.find(@nba.id)
    assert_equal true, tba.optional
    tba = BeamAngle.find(beam_angles('mac2000_lens').id)
    assert_equal false, tba.optional
  end

  def test_lantern_cascade
    @ba.lantern.destroy
    assert_raise(ActiveRecord::RecordNotFound) { BeamAngle.find(@ba.id) }
  end
end
