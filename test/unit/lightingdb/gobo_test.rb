require File.dirname(__FILE__) + '/../../test_helper'

class GoboTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :gobo_sizes, :gobos, :gobo_wheel_types
  fixtures :gobo_wheels, :gobo_wheels_lanterns, :gobo_wheels_gobos

  def setup
    @g = gobos('triangle_gobo')
    @ng = Gobo.new
    @ng.description = "New Gobo"
    @ng.manufacturer = manufacturers('martin')
  end

  def test_description
    abcd_tests @ng, "description", " -@\/';,:()", 255, ")"
    @ng.description = ""
    assert !@ng.valid?
  end

  def test_description_unique
    assert @ng.valid?
    @ng.description = @g.description
    assert !@ng.valid?
  end

  def test_number
    abcd_tests @ng, "number", "-", 8
    @ng.number = ""
    assert @ng.valid?
  end
end
