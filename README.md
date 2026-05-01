# Xinerama

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/n-at-han-k/ruby-xinerama)

Ruby FFI bindings for the Xinerama X11 extension. Query multi-monitor screen configurations with a clean, idiomatic Ruby API.

Official libXinerama repo: https://gitlab.freedesktop.org/xorg/lib/libxinerama

## Installation

Add to your Gemfile:

```ruby
gem 'xinerama'
```

Or install directly:

```bash
gem install xinerama
```

**Dependencies:** Requires `libX11` and `libXinerama` to be installed on your system.

```bash
# Debian/Ubuntu
apt-get install libx11-6 libxinerama1

# Fedora/RHEL
dnf install libX11 libXinerama

# Arch
pacman -S libx11 libxinerama
```

## Usage

### Quick Access

```ruby
require 'xinerama'

# Get all screens (lazy enumerator)
Xinerama.screens.each do |screen|
  puts "Screen #{screen.screen_number}: #{screen.width}x#{screen.height}+#{screen.x}+#{screen.y}"
end

# Check if Xinerama is active
Xinerama.active?  # => true

# Get version
Xinerama.version  # => #<Xinerama::Version 1.1>
```

### Display Connection

For multiple queries, reuse the display connection:

```ruby
Xinerama.open do |display|
  puts "Xinerama active: #{display.active?}"
  puts "Version: #{display.version}"
  puts "Extension event base: #{display.extension.event_base}"
  
  display.screens.each do |screen|
    puts screen.inspect
  end
end
```

### Screen Information

```ruby
Xinerama.open do |display|
  display.screens.each do |screen|
    screen.screen_number  # => 0
    screen.x              # => 0
    screen.y              # => 0
    screen.width          # => 1920
    screen.height         # => 1080
    screen.origin         # => [0, 0]
    screen.dimensions     # => [1920, 1080]
    screen.area           # => 2073600
    screen.aspect_ratio   # => (16/9)
    screen.to_h           # => { screen_number: 0, x: 0, y: 0, width: 1920, height: 1080 }
  end
end
```

### Finding Screens

```ruby
Xinerama.open do |display|
  # Primary screen (first in list)
  display.primary_screen

  # Find screen containing a point
  display.screen_at(100, 200)

  # Total virtual desktop dimensions
  display.total_dimensions  # => [3840, 1080]
end
```

### Lazy Evaluation

Screen queries return lazy enumerators, efficient for large multi-monitor setups:

```ruby
# Only iterates until first matching screen is found
large_screen = Xinerama.screens.find { |s| s.area > 2_000_000 }

# Chain operations without intermediate arrays
Xinerama.screens
  .select { |s| s.width > 1920 }
  .map(&:to_h)
  .first(2)
```

### Connecting to Remote Displays

```ruby
Xinerama.open("remote:0.0") do |display|
  display.screens.each { |s| puts s }
end
```

### Error Handling

```ruby
begin
  Xinerama.open do |display|
    display.extension  # Raises if Xinerama unavailable
  end
rescue Xinerama::DisplayError => e
  puts "Cannot connect to X server"
rescue Xinerama::NotAvailableError => e
  puts "Xinerama extension not available"
end
```

## API Reference

### Module Methods

| Method | Description |
|--------|-------------|
| `Xinerama.open(display_name = nil, &block)` | Open display connection |
| `Xinerama.screens(display_name = nil)` | Get lazy enumerator of screens |
| `Xinerama.active?(display_name = nil)` | Check if Xinerama is active |
| `Xinerama.version(display_name = nil)` | Get Xinerama version |

### Display

| Method | Description |
|--------|-------------|
| `#active?` | Boolean indicating Xinerama activation |
| `#available?` | Boolean indicating extension availability |
| `#screens` | Lazy enumerator of ScreenInfo objects |
| `#primary_screen` | First screen |
| `#screen_at(x, y)` | Screen containing the given point |
| `#screen_count` | Number of screens |
| `#total_dimensions` | `[width, height]` of virtual desktop |
| `#version` | Version object |
| `#extension` | Extension object with event/error bases |
| `#close` | Close display connection |
| `#closed?` | Check if connection is closed |

### ScreenInfo

| Method | Description |
|--------|-------------|
| `#screen_number` | Screen index |
| `#x`, `#y` | Origin coordinates |
| `#width`, `#height` | Dimensions |
| `#origin` | `[x, y]` |
| `#dimensions` | `[width, height]` |
| `#area` | `width * height` |
| `#aspect_ratio` | Rational width/height |
| `#contains?(x, y)` | Point containment check |
| `#to_h`, `#to_a` | Conversion methods |

## License

MIT License. See LICENSE.txt.
