# frozen_string_literal: true

require "test_helper"

class ScreenInfoTest < Minitest::Test
  def setup
    @screen = Xinerama::ScreenInfo.new(
      screen_number: 0,
      x: 100,
      y: 200,
      width: 1920,
      height: 1080
    )
  end

  def test_attributes
    assert_equal 0, @screen.screen_number
    assert_equal 100, @screen.x
    assert_equal 200, @screen.y
    assert_equal 1920, @screen.width
    assert_equal 1080, @screen.height
  end

  def test_origin
    assert_equal [100, 200], @screen.origin
  end

  def test_dimensions
    assert_equal [1920, 1080], @screen.dimensions
  end

  def test_area
    assert_equal 1920 * 1080, @screen.area
  end

  def test_aspect_ratio
    assert_equal Rational(16, 9), @screen.aspect_ratio
  end

  def test_contains_point_inside
    assert @screen.contains?(150, 250)
    assert @screen.contains?(100, 200)
    assert @screen.contains?(2019, 1279)
  end

  def test_contains_point_outside
    refute @screen.contains?(50, 200)
    refute @screen.contains?(100, 100)
    refute @screen.contains?(2020, 200)
    refute @screen.contains?(100, 1280)
  end

  def test_to_h
    expected = {
      screen_number: 0,
      x: 100,
      y: 200,
      width: 1920,
      height: 1080
    }
    assert_equal expected, @screen.to_h
  end

  def test_to_a
    assert_equal [0, 100, 200, 1920, 1080], @screen.to_a
  end

  def test_frozen
    assert @screen.frozen?
  end

  def test_equality
    other = Xinerama::ScreenInfo.new(
      screen_number: 0,
      x: 100,
      y: 200,
      width: 1920,
      height: 1080
    )
    assert_equal @screen, other
    assert_equal @screen.hash, other.hash
  end

  def test_inequality
    other = Xinerama::ScreenInfo.new(
      screen_number: 1,
      x: 100,
      y: 200,
      width: 1920,
      height: 1080
    )
    refute_equal @screen, other
  end

  def test_inspect
    assert_match(/ScreenInfo/, @screen.inspect)
    assert_match(/1920x1080/, @screen.inspect)
    assert_match(/\+100\+200/, @screen.inspect)
  end
end
