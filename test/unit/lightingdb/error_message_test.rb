require File.dirname(__FILE__) + '/../../test_helper'

class ErrorMessageTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :error_messages, :error_messages_lanterns

  def setup
    @er = ErrorMessage.find(1)
    @lan = Lantern.find(@er.lanterns.first.id)
  end

  def test_joins
    errs = @lan.error_messages
    assert_equal errs.length, 2
    lans = @er.lanterns
    assert_equal lans.length, 2
    lans = ErrorMessage.find_by_error("RgER").lanterns
    assert_equal lans.length, 1
    assert_equal lans.first.name, lanterns('mac500_lantern').name
    errs = Lantern.find_by_name(lanterns('mac600_lantern').name).error_messages
    assert_equal errs.length, 2
  end

  def test_destroy
    @er.destroy
    assert_raise(ActiveRecord::RecordNotFound) { ErrorMessage.find(@er.id) }
    assert Lantern.find(@lan.id)
  end

  def test_cascade_lantern
    cascade_tests(Lantern, ErrorMessage, :a => @lan, :b => @er)
  end

  def test_cascade_error
    cascade_tests(ErrorMessage, Lantern, :a => @er, :b => @lan)
  end

  def test_error
    assert @er.valid?
    abcd_tests @er, "error", " -.\:/@,", 16
  end

  def test_name
    assert @er.valid?
    abcd_tests @er, "name", " -:;,.", 255
  end

  def test_short_description
    assert @er.valid?
    abcd_tests @er, "short_description", " -@';\/,.:()", 255, ".)"
  end

  def test_long_description
    assert @er.valid?
    abcd_tests @er, "long_description", " -@';\/,.:()", 0, ".)"
  end
end
