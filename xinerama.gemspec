# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "xinerama"
  spec.version       = "1.0.0"
  spec.authors       = ["Nathan"]
  spec.email         = ["nathankidd@hey.com"]

  spec.summary       = "Ruby FFI bindings for the Xinerama X11 extension"
  spec.description   = "Provides a clean Ruby interface to query Xinerama screen information for multi-monitor X11 setups"
  spec.homepage      = "https://github.com/n-at-han-k/ruby-xinerama"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files         = Dir["lib/**/*.rb"] + ["README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.15"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
end
