require File.dirname(__FILE__) + '/../test_helper'
require 'lightingdb_controller'

# FIXME: All tests are outdated, no longer work
# TODO Replace asset_tag tests
# TODO Add validation etc tests

# Re-raise errors caught by the controller.
class LightingdbController; def rescue_action(e) raise e end; end

class LightingdbControllerTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :gobo_sizes, :gobos, :gobo_wheel_types
  fixtures :gobo_wheels, :gobo_wheels_lanterns, :gobo_wheels_gobos
  fixtures :beam_angles, :currents, :dmx_channels
  fixtures :error_messages, :error_messages_lanterns
  fixtures :lamps, :lamps_lanterns
  fixtures :notes, :lanterns_notes
  fixtures :comatose_pages

  def setup
    @controller = LightingdbController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

#
### Index
#

  def test_index
    get :index
    assert_response :success
    assert_template "lightingdb/index"
    assert !flash[:notice]
    assert_select 'title', "Lighting Database"
    assert_select 'h1', {:count => 1, :text => "Lighting Database"}
    assert_select 'h3', "Disclaimer"
    assert_select "div" do
      assert_select "h3", "Martin"
      assert_select "a", :minimum => 3
      assert_select 'a', "Mac 500"
    end
    assert_select "div" do
      assert_select "h3", "Clay Paky"
      assert_select 'a', "Golden Scan HPE"
    end
  end

#
###   Showlantern
#

  def test_showlantern_page
    lantern = lanterns('mac500_lantern')
    assert_get_show_page(:show_lantern, lantern)
    assert_template "lightingdb/show_lantern"
    assert !flash[:notice]
    assert_select "h1", "Mac 500"
    assert_select "h2", "Lantern Information"
  end

  def test_showlantern_weight
    lantern = lanterns('mac500_lantern')
    assert_get_show_page(:show_lantern, lantern)
    assert_select 'dt', "Weight"
    assert_select 'dt + dd', lantern.weight.to_s + 'kg'
  end

  def test_showlantern_lantern_type
    lantern = lanterns('mac500_lantern')
    assert_get_show_page(:show_lantern, lantern)
    assert_select 'dt', 'Lantern Type'
    assert_select 'dt + dd', lantern.lantern_type.name
  end

#  def test_showlantern_dmx_channel_table
#    lantern = lanterns('mac500_lantern')
#    assert_get_show_page(:show_lantern, lantern)
#    assert_select 'dt', 'DMX Channels'
#    chs = lantern.dmx_channels
#    assert_select 'dt + dd' do
#      assert_select 'table > tr', :count => chs.count + 1
#    end
#    table = { :tag => "table", :parent => dd}
#    assert_tag table
#    assert_tag table.merge({ :attributes => { :class => "border" }, :children => { :count => chs.count + 1, :only => { :tag => "tr" } } })
#    tr = { :tag => "tr", :parent => table }
#    assert_siblings("th", tr, ["DMX Mode", "Channels", "Description"])
#    for dmx in chs
#      assert_siblings("td", tr, [dmx.mode, dmx.channels.to_s, dmx.description] )
#    end
#  end

#  def test_showlantern_dmx_channel_line
#    lantern = @goldenscan_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    dt_title = { :tag => "dt", :content => "DMX Channels" }
#    assert_tag dt_title
#    assert_tag( :tag => "dd",
#                :content => lantern.dmx_channels.first.channels.to_s,
#                :after => dt_title )
#  end
#
#  def test_showlantern_no_dmx_channel
#    assert_get_show_page(:show_lantern)
#    assert_no_tag :tag => "dt", :content => "DMX Channels"
#  end
#
#  def test_showlantern_no_beam_angle
#    assert_get_show_page(:show_lantern)
#    assert_no_tag :tag => "dt", :content => "Lens"
#  end
#
#  def test_showlantern_single_fixed_beam_angle
#    lantern = @mac600_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    dt = { :tag => "dt", :content => "Lens" }
#    assert_tag dt
#    assert_tag :tag => "dd", :after => dt, :content => "Beam Angle : " + lantern.beam_angles.first.minangle.to_s + "&deg;"
#  end
#
#  def test_showlantern_single_zoom_beam_angle
#    lantern = @mac2000_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    dt = { :tag => "dt", :content => "Lens" }
#    assert_tag dt
#    dd = { :tag => "dd", :after => dt }
#    assert_tag dd
#    ul = { :tag => "ul", :parent => dd }
#    assert_tag ul
#    assert_siblings("li", ul, ["Minimum Angle : " + lantern.beam_angles.first.minangle.to_s + "&deg;",
#                               "Maximum Angle : " + lantern.beam_angles.first.maxangle.to_s + "&deg;" ])
#  end
#
#  def test_showlantern_multiple_beam_angle
#    lantern = @multi_lens_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    dt = { :tag => "dt", :content => "Lens" }
#    assert_tag dt
#    dd = { :tag => "dd", :after => dt }
#    assert_tag dd
#    table = { :tag => "table", :parent => dd}
#    assert_tag table
#    assert_tag table.merge({ :attributes => { :class => "border" }, :children => { :count => lantern.beam_angles.count + 1, :only => { :tag => "tr" } } })
#    tr = { :tag => "tr", :parent => table }
#    assert_siblings("th", tr, ["&#160;", "Minimum Angle", "Maximum Angle"])
#    for ba in lantern.beam_angles
#      if ba.zoom?
#        assert_siblings("td", tr, [ba.optional_str, ba.minangle.to_s + "&deg;", ba.maxangle.to_s + "&deg;"])
#      else
#        content =  ba.minangle.to_s + "&deg;"
#        assert_siblings("td", tr, [ba.optional_str, { :content => content, :attributes => { :colspan => "2" }}] )
#      end
#    end
#  end
#
#  def test_showlantern_no_lamp
#    assert_get_show_page(:show_lantern)
#    assert_no_tag :tag => "dt", :content => /Lamp/
#  end
#
#  def test_showlantern_single_lamp
#    lantern = @goldenscan_lantern
#    lamp = lantern.lamps.first
#    assert_get_show_page(:show_lantern, lantern)
#    assert_select "dt", "Lamp"
#    assert_select "dt + dd" do
#      assert_select "ul.nobullet" do
#        assert_select "li", "Lamp : " + lamp.name
#        assert_select "li", "Manufacturer : " + lamp.manufacturer.name
#        assert_select "li", "Power : " + lamp.power.to_s + "W"
#        assert_select "li", "Life : " + lamp.life.to_s + "Hr"
#      end
#    end
#  end
#
#  def test_showlantern_many_lamps
#    lantern = @mac500_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    dt = { :tag => "dt", :content => "Lamps" }
#    assert_tag dt
#    dd = { :tag => "dd", :after => dt }
#    assert_tag dd
#    table = { :tag => "table", :attributes => { :class => "border" }, :parent => dd, :children => { :count => lantern.lamps.count + 1, :only => { :tag => "tr" } } }
#    assert_tag table
#    tr = { :tag => "tr", :parent => table }
#    assert_tag tr
#    assert_siblings("th", tr, ["Lamp", "Manufacturer", "Power", "Life"])
#    for lamp in lantern.lamps
#      assert_siblings("td", tr, [lamp.name, lamp.manufacturer.name, lamp.power.to_s + "W", lamp.life.to_s + "Hr"])
#    end
#  end
#
#  def test_showlantern_no_current
#    assert_get_show_page(:show_lantern)
#    assert_no_tag :tag => "dt", :content => "Power"
#  end
#
#  def test_showlantern_many_current
#    lantern = @mac500_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    dt = { :tag => "dt", :content => "Lamps" }
#    assert_tag dt
#    dd = { :tag => "dd", :after => dt }
#    assert_tag dd
#    table = { :tag => "table", :parent => dd }
#    assert_tag table
#    assert_tag table.merge({:attributes => { :class => "border" }, :children => { :count => lantern.currents.count + 1, :only => { :tag => "tr" } } })
#    tr = { :tag => "tr", :parent => table }
#    assert_tag tr
#    assert_siblings("th", tr, ["Voltage", "Current", "Frequency"])
#    for current in lantern.currents
#      assert_siblings("td", tr, [current.voltage.to_s + "V", current.current.to_s + "A", current.frequency.to_s + "Hz" ])
#    end
#  end
#
#  def test_showlantern_no_showgobos
#    assert_get_show_page(:show_lantern)
#    assert_no_tag :tag => "dt", :child => { :tag => "a", :content => "Gobos" }
#  end
#
#  def test_showlantern_showgobos
#    lantern = @mac500_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    assert_tag( :tag => "dt",
#                :child => {
#                  :tag => "a",
#                  :content => "Gobos",
#                  :attributes => {
#                    :href => showgobos_url(:manufacturer => lantern.manufacturer.name, :lantern => lantern.name)}})
#  end
#
#  def test_showlantern_no_showerrors
#    assert_get_show_page(:show_lantern)
#    assert_no_tag :tag => "dt", :child => { :tag => "a", :content => "Errors" }
#  end
#
#  def test_showlantern_showerrors
#    lantern = @mac500_lantern
#    assert_get_show_page(:show_lantern, lantern)
#    assert_tag( :tag => "dt",
#                :child => {
#                  :tag => "a",
#                  :content => "Errors",
#                  :attributes => {
#                    :href => showerrors_url(:manufacturer => lantern.manufacturer.name, :lantern => lantern.name)}})
#  end

#
### Showerrors
#

#  def test_showerrors_page
#    lantern = @mac500_lantern
#    assert_invalid_lantern_response :show_errors
#    assert_get_show_page(:show_errors, lantern)
#    assert_template "lightingdb/show_errors"
#    assert !flash[:notice]
#    assert_select "h1", lantern.name + " - Errors"
#    assert_select "dl" do
#      assert_select "a[href=\"#{showlantern_url(:manufacturer => lantern.manufacturer.name, :lantern => lantern.name )}\"]",
#                    "Return to " + lantern.name + " information"
#      assert_select "a", "Return to index"
#    end
#  end

#  def test_showerrors_table
#    lantern = @mac500_lantern
#    assert_get_show_page(:show_errors, lantern)
#    table = { :tag => "table", :sibling => {:tag => "h1"} }
#    assert_tag table
#    assert_tag table.merge({ :attributes => { :class => "border" }, :children => { :count => lantern.error_messages.count + 1, :only => {:tag => "tr"}}})
#    tr = { :tag => "tr", :parent => table }
#    assert_siblings("th", tr, ["Error", "Name", "Description"])
#    for error in lantern.error_messages
#      err = error.error
#      err = { :child => { :tag => "a", :content => error.error } } if error.long_description
#      assert_siblings("td", tr, [error.error, error.name, error.short_description])
#    end
#  end

#
### Showerror
#

#  def test_showerror_page
#    lantern = @mac500_lantern
#    error = @mac500_lantern.error_messages.first
#    assert_invalid_lantern_response :show_error, :error => error.error
#    assert_get_show_page(:show_error, lantern, :error => error.error)
#    assert_template "lightingdb/show_error"
#    assert !flash[:notice]
#    assert_select 'h1', "Mac 500 - Error:" + error.error
#  end


#  def test_showerror_list
#    lantern = @mac500_lantern
#    error = @mac500_lantern.error_messages.first
#    assert_get_show_page(:show_error, lantern, :error => error.error)
#    dl = { :tag => "dl", :sibling => { :tag => "h1" } }
#    assert dl
#    assert_siblings(/dd|dt/, dl, [{ :tag => "dt", :content => "Error" },
#                               { :content => error.error },
#                               { :tag => "dt", :content => "Name" },
#                               { :content => error.name },
#                               { :tag => "dt", :content => "Short Description" },
#                               { :content => error.short_description },
#                               { :tag => "dt", :content => "Long Description" },
#                               { :content => error.long_description },
#                               { :tag => "dt",
#                                 :child => {
#                                   :tag => "a",
#                                   :content => "Return to "+ lantern.name + " error list",
#                                   :attributes => { :href => showerrors_url(:manufacturer => lantern.manufacturer.name, :lantern => lantern.name ) }}},
#                               { :tag => "dt",
#                                 :child => {
#                                   :tag => "a",
#                                   :content => "Return to " + lantern.name + " information",
#                                   :attributes => { :href => showlantern_url(:manufacturer => lantern.manufacturer.name, :lantern => lantern.name ) }}},
#                               { :tag => "dt",
#                                 :child => {
#                                   :tag => "a",
#                                   :content => "Return to index"}}])
#  end

#
### Showgobos
#

#  def test_showgobos_page
#    lantern = @mac500_lantern
#    assert_invalid_lantern_response :show_gobos
#    assert_get_show_page(:show_gobos, lantern)
#    assert_template "lightingdb/show_gobos"
#    assert !flash[:notice]
#    assert_select "h1", lantern.name + " - Gobos"
#    assert_select "h1 + dl"
#  end
#

#  def test_showgobos_tables
#    lantern = @mac500_lantern
#    assert_get_show_page(:show_gobos, lantern)
#    dl = { :tag => "dl", :sibling => { :tag => "h1" }}
#    assert_tag dl
#    dd = { :tag => "dd", :parent => dl }
#    assert_tag dd
#    dlar = []
#    for gw in lantern.gobo_wheels
#      dlar << { :tag => "dt", :content => gw.gobo_wheel_type.name }
#      dlar << dd
#    end
#    dlar << { :tag => "dt", :child => {
#        :tag => "a",
#        :content => "Return to " + lantern.name + " information",
#        :attributes => { :href => showlantern_url(:manufacturer => lantern.manufacturer.name, :lantern => lantern.name ) }}}
#    dlar << { :tag => "dt", :child => { :tag => "a", :content => "Return to index"}}
#    assert_siblings(/dt|dd/, dl, dlar)
#    for gw in lantern.gobo_wheels
#      dt = { :tag => "dt", :content => gw.gobo_wheel_type.name, :parent => dl }
#      assert_tag dt
#      ddt = { :tag => "dd", :after => dt }
#      assert_tag ddt
#      table = { :tag => "table", :parent => ddt }
#      assert_tag table
#      assert_tag table.merge({ :attributes => {:class => "border"}, :children => {:count => 3, :only => {:tag => "tr"}}})
#      tr = { :tag => "tr", :parent => table }
#      assert_tag tr
#      row1 = []
#      row2 = []
#      row3 = []
#      (1..gw.quantity).each do |i| 
#        row1 << i.to_s
#        if gw.gobo(i) != nil
#          gobo = gw.gobo(i)
#          row2 << gobo.description
#          row3 << { :child => { :tag => "img", :attributes => { :alt => "Gobo image" }}}
#        else
#          row2 << "&#160;"
#          row3 << "&#160;"
#        end
#      end
#       
#      assert_siblings("th", tr, row1)
#      assert_siblings("td", tr, row2)
#      assert_siblings("td", tr, row3)
#    end
#  end
end
