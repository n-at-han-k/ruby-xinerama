# frozen_string_literal: true

require "test_helper"

class ExtensionTest < Minitest::Test
  def setup
    @extension = Xinerama::Extension.new(event_base: 89, error_base: 153)
  end

  def test_attributes
    assert_equal 89, @extension.event_base
    assert_equal 153, @extension.error_base
  end

  def test_to_h
    expected = { event_base: 89, error_base: 153 }
    assert_equal expected, @extension.to_h
  end

  def test_frozen
    assert @extension.frozen?
  end

  def test_inspect
    assert_match(/Extension/, @extension.inspect)
    assert_match(/89/, @extension.inspect)
    assert_match(/153/, @extension.inspect)
  end
end

class VersionTest < Minitest::Test
  def setup
    @version = Xinerama::Version.new(major: 1, minor: 1)
  end

  def test_attributes
    assert_equal 1, @version.major
    assert_equal 1, @version.minor
  end

  def test_to_s
    assert_equal "1.1", @version.to_s
  end

  def test_to_a
    assert_equal [1, 1], @version.to_a
  end

  def test_to_h
    expected = { major: 1, minor: 1 }
    assert_equal expected, @version.to_h
  end

  def test_frozen
    assert @version.frozen?
  end

  def test_comparable
    v10 = Xinerama::Version.new(major: 1, minor: 0)
    v11 = Xinerama::Version.new(major: 1, minor: 1)
    v20 = Xinerama::Version.new(major: 2, minor: 0)

    assert v10 < v11
    assert v11 < v20
    assert v20 > v10
    assert_equal v11, Xinerama::Version.new(major: 1, minor: 1)
  end

  def test_inspect
    assert_match(/Version/, @version.inspect)
    assert_match(/1\.1/, @version.inspect)
  end
end
