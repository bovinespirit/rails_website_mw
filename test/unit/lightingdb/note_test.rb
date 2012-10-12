require File.dirname(__FILE__) + '/../../test_helper'

class NoteTest < Test::Unit::TestCase
  fixtures :lantern_types, :manufacturers, :lanterns
  fixtures :notes, :lanterns_notes

  def setup
    @n = Note.find(notes('mac_note1').id)
    @nl = Note.new
    @nl.title = "New Note"
    @nl.note = "Text"
  end

  def test_title
    abcd_tests @nl, "title", " ,.:;\/?-()!", 255, ".)?!"
    @nl.title = ""
    assert !@nl.valid?
  end

  def test_note
    abcd_tests @nl, "note", " ,.:;\/?-()!", 0, ".)?!"
    @nl.note = ""
    assert !@nl.valid?
  end

  def test_joins
    assert_equal lanterns('goldenscan_lantern').notes.length, 1
    assert_equal lanterns('mac500_lantern').notes.length, 2
    assert_equal @n.lanterns.length, 2
  end

  def test_destroy
    @n.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Note.find(@n.id) }
    assert Lantern.find(lanterns('mac500_lantern').id)
  end

  def test_make_joins
    @nl.lanterns << lanterns('mac600_lantern')
    @nl.lanterns << lanterns('mac2000_lantern')
    @nl.save!
    tn = Note.find(@nl.id)
    assert_equal tn.lanterns.length, 2
    assert_equal lanterns('mac2000_lantern').notes.first.id, tn.id
  end

  def test_remove_joins
    assert_equal @n.lanterns.length, 2
    @n.lanterns.delete(lanterns('mac500_lantern'))
    assert_equal @n.lanterns.length, 1
  end

  def test_cascade_lantern
    cascade_tests(Lantern, Note, :a => notes('mac_note1').lanterns.first, :b => notes('mac_note1'))
  end

  def test_cascade_note
    cascade_tests(Note, Lantern, :a => notes('mac_note2'), :b => notes('mac_note2').lanterns.first)
  end
end
