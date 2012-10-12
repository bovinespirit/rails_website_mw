require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_dsl.rb"

class LightingRedirectsTest < ActionController::IntegrationTest
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :gobo_sizes, :gobos, :gobo_wheel_types
  fixtures :gobo_wheels, :gobo_wheels_lanterns, :gobo_wheels_gobos
  fixtures :beam_angles, :currents, :dmx_channels
  fixtures :error_messages, :error_messages_lanterns
  fixtures :lamps, :lamps_lanterns
  fixtures :notes, :lanterns_notes

  def test_showgobos_no_wheels
    session = open_session()
    session.get 'lightingdb/show_gobos', :manufacturer => "No Maker", :lantern => "No Info"
    session.assert_redirected_to :action => :show_lantern
    session.follow_redirect!
  end

  def test_showerror_invalid_error
    get 'lightingdb/show_error', :manufacturer => "Martin", :lantern => "Mac 500", :error => "arse"
    assert_redirected_to :action => :show_errors
    follow_redirect!
  end

  def test_showerror_no_errors
    get 'lightingdb/show_error', :manufacturer => "No Maker", :lantern => "No Info"
    assert_redirected_to :action => :show_errors
    follow_redirect!
    assert_redirected_to :action => :show_lantern
    follow_redirect!
  end

  def test_showerrors_no_errors
    get 'lightingdb/show_errors', :manufacturer => "No Maker", :lantern => "No Info"
    assert_redirected_to :action => :show_lantern
    follow_redirect!
  end

  def test_showlantern_page
    assert_invalid_lantern_response :show_lantern
  end
  
  private
  def assert_invalid_lantern_response(page, extraparams = {})
    params = {:manufacturer => "Martin", :lantern => "Mac 500"}.merge(extraparams)
    get 'lightingdb/show_lantern', params
    assert_response :success
    get 'lightingdb/show_lantern', params.merge({:lantern => "Mic 500"})
    assert_redirected_to :action => :index
    get 'lightingdb/show_lantern', params.merge({:manufacturer => "Mirtin"})
    assert_redirected_to :action => :index
  end


end