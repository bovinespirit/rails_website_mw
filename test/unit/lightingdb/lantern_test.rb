require File.dirname(__FILE__) + '/../../test_helper'

class LanternTest < Test::Unit::TestCase
  fixtures  :manufacturers, :lantern_types, :lanterns

  def setup
    @lantern = Lantern.find_by_name('Mac 500')
  end

  def test_mac500create
    assert_kind_of Lantern, @lantern
    assert_equal @lantern.id, lanterns('mac500_lantern').id
    assert_equal @lantern.name, lanterns('mac500_lantern').name
    assert_kind_of Manufacturer, @lantern.manufacturer
    assert_equal @lantern.manufacturer.name, Manufacturer.find(lanterns('mac500_lantern').manufacturer_id).name
    assert_kind_of LanternType, @lantern.lantern_type
    assert_equal @lantern.lantern_type.name, LanternType.find(lanterns('mac500_lantern').lantern_type_id).name
  end

  def test_makegoldenscan
    newlan = Lantern.new
    assert !newlan.save
    newlan.weight = lanterns('goldenscan_lantern').weight
    newlan.name = lanterns('goldenscan_lantern').name
    maker = Manufacturer.find(lanterns('goldenscan_lantern').manufacturer_id)
    newlan.manufacturer = maker
    assert_equal newlan.name, Lantern.find_by_name(lanterns('goldenscan_lantern').name).name
    assert !newlan.save
    newlan.manufacturer = Manufacturer.find(lanterns('mac500_lantern').manufacturer_id)
    assert newlan.save
    newlan.manufacturer = maker
    newlan.name = "New "+lanterns('goldenscan_lantern').name
    newlan.lantern_type = LanternType.find(lanterns('goldenscan_lantern').lantern_type_id)
    assert newlan.save

    loadlan = Lantern.find(newlan.id)
    assert_equal loadlan.name, newlan.name
    assert_equal loadlan.lantern_type.id, lanterns('goldenscan_lantern').lantern_type_id
    assert_equal loadlan.manufacturer, maker
  end

  def test_name
    @lantern.name = "New Lantern"
    assert @lantern.valid?
    abcd_tests @lantern, "name", " ", 255
    @lantern.name = ""
    assert !@lantern.valid?
  end
end
