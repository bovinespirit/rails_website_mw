require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  fixtures :contacts

  def test_fn_class_person
    assert contact = Contact.find(2)
    assert_equal "fn", contact.fn_class
  end  

  def test_fn_class_org
    assert contact = Contact.find(1)
    assert_equal "fn org", contact.fn_class
  end  
end
