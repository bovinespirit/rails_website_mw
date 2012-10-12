require File.dirname(__FILE__) + '/../../test_helper'

class ContactlinkDropTest < Test::Unit::TestCase
  fixtures :contacts
  
  def setup
    assert @processing_context = Comatose::ProcessingContext.new(ComatosePage.find(5))
    assert @drop = @processing_context['contactlink']
    @drop.context = @processing_context
    assert @drop.to_liquid
  end
  
  def test_link
    assert str = @drop['starlight']
    assert str.include?("<span")
    assert str.include?('href="http://www.starlight-design.co.uk/"')
  end
end