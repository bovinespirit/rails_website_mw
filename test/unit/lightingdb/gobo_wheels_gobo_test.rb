require File.dirname(__FILE__) + '/../../test_helper'

class GoboWheelsGoboTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :gobo_sizes, :gobos, :gobo_wheel_types
  fixtures :gobo_wheels, :gobo_wheels_lanterns, :gobo_wheels_gobos

  def test_position
    gwg = GoboWheelsGobo.find(1)
    gwg.position = ""
    assert !gwg.valid?
    gwg.position="a"
    assert !gwg.valid?
    gwg.position = 999
    assert gwg.valid?
  end
end
