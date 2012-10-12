ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...

  def abcd_tests(obj, mem, extrachars, maxlen = 0, lastchars = "")
# obj = object being tested - Must Be Valid!
# mem = object member name i.e.  obj.member
# extrachars = characters that regex should allow, on top of alphabet, numbers and '_'
# maxlen = maximum length of string allowed, 0=no maximum length
# lastchars = Final characters allowed(other than alphabet, numbers)
#
    oddchars = " :;,.()<>*&^%$@!#~{}[]\|/?'-=+"
    allch = ""
    ('a'..'z').each { |c| allch += c }
    ('0'..'9').each { |c| allch += c }
    ('A'..'Z').each { |c| allch += c }
    allch += "_"

    assert obj.valid?

    if maxlen == 0
      assert_abcd obj, mem, allch, true
    else
      while !allch.empty? do
        assert_abcd obj, mem, allch.slice!(0...maxlen), true
      end
      string_length_tests obj, mem, maxlen
    end

    te = String.new(extrachars)
    while !te.empty? do
      oddchars.slice!(te.slice!(0...1))
    end
    while !oddchars.empty? do
      c = oddchars.slice!(0...1)
      assert_abcd obj, mem, "a" + c + "b", false
    end

    assert_abcd obj, mem, "ab", true
    assert_abcd obj, mem, " abcd", false
    assert_abcd obj, mem, "abcd ", false

    while !extrachars.empty? do
      c = extrachars.slice!(0...1)
      assert_abcd obj, mem, "a" + c + "b", true
      assert_abcd obj, mem, "ab" + c, (lastchars.slice!(c) != nil)
      assert_abcd obj, mem, c + "ab", false
    end
  end

  def assert_abcd(obj, mem, string, valid)
    obj.send(mem + "=", string)
    neg = ""
    res = obj.valid?
    if !valid
      res = !res 
      neg = "not"
    end
    assert res, :message => "'#{string}' should #{neg} be valid in #{mem}"
  end

  def string_length_tests(obj, mem, maxlen)
    ch = ""
    maxlen.times { ch += "X" }
    obj.send(mem + "=", ch)
    assert obj.valid?, :message => "#{mem} should allow strings up to #{maxlen}"
    ch += "X"
    obj.send(mem + "=", ch)
    assert !obj.valid?, :message => "#{mem} should not allow strings longer than #{maxlen}"
  end

  def cascade_tests(tbla, tblb, ob = {})
# tbla = Table from which object will be removed
# tblb = Table linked via join to tbla
# ob {}
#    :a = Object to be removed from tbla
#    :b = Object not to be removed from tblb
#    :join_table = Name of join table if it's wierd

    ob[:join_table] ||= [tbla.table_name, tblb.table_name].sort.join("_")
    ob[:a] ||= tbla.find(:all).first
    ob[:b] ||= tblb.find(:all).first
    obja = ob[:a]
    objb = ob[:b]
    jointbl = ob[:join_table]

    assert tbla.find(obja.id), :message => "object A not found"
    assert tblb.find(objb.id), :message => "object B not found"

    lst = tblb.find_by_sql("SELECT #{tblb.table_name}.* FROM #{tblb.table_name}, #{jointbl} "+
                           "  WHERE #{tblb.table_name}.id = #{jointbl}.#{tblb.table_name.singularize}_id " +
                           "    AND #{jointbl}.#{tbla.table_name.singularize}_id = #{obja.id}")
    assert_equal lst.length, obja.send(tblb.table_name).size, :message => "The join table has wrong number of entries"
    assert lst.length > 1, :message => "Join table does not have enough entries joining #{tblb.table_name} to #{tbla.table_name}:#{obja.id}"

    assert objb.send(tbla.table_name).size > 1, :message => "Join table does not have enough entries joining #{tbla.table_name} to #{tblb.table_name}:#{objb.id}"
    assert objb.send(tbla.table_name).find(obja.id), :message => "#{tblb.table_name}:#{objb.id} is not joined to #{tbla.table_name}:#{obja.id}"

    obja.destroy

    assert_raise(ActiveRecord::RecordNotFound) { objb.send(tbla.table_name).find(obja.id) }
    assert tblb.find(objb.id), :message => "obj[a].destroy has destroyed obj[b]"
    lst = tblb.find_by_sql("SELECT #{tblb.table_name}.* FROM #{tblb.table_name}, #{jointbl} "+
                           "  WHERE #{tblb.table_name}.id = #{jointbl}.#{tblb.table_name.singularize}_id " +
                           "    AND #{jointbl}.#{tbla.table_name.singularize}_id = #{obja.id}")
    assert_equal lst.length, 0, :message => "Entries have been left in join table"
  end

  def add_padding_to_size(sz)
    [sz[0] + Photo::PADDING, sz[1] + Photo::PADDING]
  end

### Functional

  def assert_get_show_page(page, lantern = @noinfo_lantern, extra_param = {})
#  gets a show_xx page, checks for success
#  default lantern has no infomation associated with it
#   page = symbol of action, e.g. :show_lantern
#   lantern = lantern object to be found
#   extra_param = Extra parameters to go on the end of the URL
    param = { :manufacturer => lantern.manufacturer.name, :lantern => lantern.name }.merge(extra_param)
    get page, param
    assert_response :success
    assert_equal lantern, assigns["lantern"]
  end

# TODO: Sort this mess out
  def assert_siblings(tag, parent, content)
#   Looks at a bunch of siblings with a common parent
#    e.g. <tr>
#           <td>cell 1</td>
#           <td>cell 2</td>
#         </tr>
#    tag = 'td', parent is { :tag => 'tr' }, content is ["cell 1", "cell 2"]
#   If a cell of the array is a hash that is used instead
#   The array is in the order that the items appear
    assert content.is_a?(Array)
    assert_tag parent
    tag = { :tag => tag } if !tag.is_a?(Hash)
    assert_tag parent.merge({ :children => { :count => content.size, :only => tag } })
#    assert_no_tag parent.merge({ :children => { :count => (content.size + 1), :only => tag } })
    tag = tag.merge({:parent => parent })
    cells = []
    (0...content.size).each do |i|
      if content[i].is_a?(Hash)
        cells[i] = tag.merge(content[i])
      else
        cells[i] = tag.merge({:content => content[i] })
      end
      assert_tag cells[i]
    end
    (0...content.size).each do |i|
#      assert_tag cells[i].merge({ :after => cells[i-1] }) if i > 0
#      assert_tag cells[i].merge({ :before => cells[i+1] }) if i < (content.size - 1)
    end
  end

# Photos

  def assert_thumbbox(firstid, secondid)
    assert_select "#thumbbox" do
      first = "a#thumb_#{firstid}"
      second = "a#thumb_#{secondid}"
      assert_select first
      assert_select "#{first} > img"
      assert_select second
      assert_select "#{second} > img"
      assert_select "#{first} + #{second}"
    end
  end
  
# Tags
  def assert_tag_cloud()
    assert_select '#cloud' do
      Tag.counts.each do |tag|
        assert_select 'a', {:text => tag.name, :count => 1}, "Could not find tag:#{tag.name} in cloud"
        assert_select %Q|a[href="#{tag_page_url(:tag => tag.name)}"]|
      end
    end
  end
  
# Check that the right number of tags are present in tags
# tags = Tag.counts, probably
# tallies = { 'tag name' => quantity }

  def assert_tag_counts(tags, tallies)
    for tag in tags do
      assert_equal tag.count, tallies.delete(tag.name), "tag.count did not match tallies value: #{tag.name}" if tallies.include?(tag.name)
    end
    tallies.each do |k, v|
      if v == 0 then
        assert_equal 0, Tag.find_by_name(k).taggings.count
        tallies.delete(k)
      end
    end
    assert tallies.empty?, "Not all tags in 'tallies' were present in 'tags'.  Missing were: #{tallies.keys.join(', ')}."
  end
end
