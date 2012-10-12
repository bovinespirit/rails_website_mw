require File.dirname(__FILE__) + '/../../test_helper'

# Add :order testing for :gobos and :lamps

class ManufacturerTest < Test::Unit::TestCase
  fixtures  :manufacturers, :lantern_types, :lanterns
  fixtures :gobos, :lamps

  def setup
    @lm = Manufacturer.find(manufacturers('martin').id)
    @nlm = Manufacturer.new
    @nlm.name = "New Manufacturer"
    @nlm.www = "www.newman.com"
  end

  def test_update
    assert @nlm.save
    tlm = Manufacturer.find(@nlm.id)
    assert_equal @nlm.id, tlm.id
    newname = "Changed name"
    newwww = "www.new.com"
    tlm.name = newname
    tlm.www = newwww
    assert tlm.save
    tlm = Manufacturer.find(@nlm.id)
    assert_equal newname, tlm.name
    assert_equal newwww, tlm.www
  end

  def test_name
    abcd_tests @nlm, "name", " ", 255
    @nlm.name = ""
    assert !@nlm.valid?
  end

  def test_name_unique
    assert @nlm.valid?
    @nlm.name = @lm.name
    assert !@nlm.valid?
  end

  def test_www_format
    assert @lm.valid?
    @lm.www = "www.abcd.com"
    assert @lm.valid?
    @lm.www = "www.abc.def.com"
    assert @lm.valid?
    @lm.www = "www.com"
    assert !@lm.valid?
    @lm.www = "wwwcom"
    assert !@lm.valid?
  end

  def test_lantern_order
    ta = manufacturers('martin').lanterns.sort { |x, y| x.name <=> y.name }
    assert_equal ta[1], manufacturers('martin').lanterns[1]
    assert_equal ta[2], manufacturers('martin').lanterns[2]
  end

  def test_lantern_makers
    lma = Manufacturer.lantern_makers
    for lm in lma
      assert Lantern.find_by_manufacturer_id(lm.id)
      if lm.name == "Martin"
        assert_equal lm.lanterns[1], manufacturers('martin').lanterns[1]
      end
    end
  end
end
