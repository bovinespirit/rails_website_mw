require File.dirname(__FILE__) + '/../../test_helper'

class DmxChannelTest < Test::Unit::TestCase
  fixtures :manufacturers, :lantern_types, :lanterns
  fixtures :dmx_channels

  def setup
    @dc = DmxChannel.find(:first)
    @ndc = @dc.clone
    @ndc.mode = "New mode"
  end

  def test_create
    assert @ndc.save
    assert DmxChannel.find(@ndc.id)
  end

  def test_destroy
    @dc.destroy
    assert_raise(ActiveRecord::RecordNotFound) { DmxChannel.find(@dc.id) }
  end

  def test_cascade
    @dc.lantern.destroy
    assert_raise(ActiveRecord::RecordNotFound) { DmxChannel.find(@dc.id) }
  end

  def test_strings_description
    @ndc.description = ""
    assert @ndc.valid?
    @ndc.description = " false"
    assert !@ndc.valid?
    @ndc.description = ""
    abcd_tests @ndc, "description", " ,()-.\/:", 255
  end
  
  def test_strings_mode
    assert @ndc.valid?
    @ndc.mode = ""
    assert !@ndc.valid?
    @ndc.mode = "Mode 1"
    abcd_tests @ndc, "mode", " -.", 255
  end

  def test_numericality
    @ndc.channels = "hello"
    assert !@ndc.valid?
    @ndc.channels = 3.4
    assert !@ndc.valid?
  end

  def test_unique
    @ndc.mode = @dc.mode
    assert !@ndc.valid?
  end
end
