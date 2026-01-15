# frozen_string_literal: true

require_relative "lib/my_tank_info/version"

Gem::Specification.new do |spec|
  spec.name = "my_tank_info"
  spec.version = MyTankInfo::VERSION
  spec.authors = ["Kyle Keesling"]
  spec.email = ["me@kylekeesling.com"]

  spec.summary = "A ruby gem to communicate with MyTankInfo (mytankinfo.com)"
  spec.homepage = "https://github.com/kylekeesling/my_tank_info"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kylekeesling/my_tank_info"
  spec.metadata["changelog_uri"] = "https://github.com/kylekeesling/my_tank_info/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2"
  spec.add_dependency "activesupport", ">= 8"
  spec.add_dependency "ostruct"

  spec.add_development_dependency "debug"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
