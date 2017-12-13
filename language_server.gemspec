
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "language_server/version"

Gem::Specification.new do |spec|
  spec.name          = "language_server"
  spec.version       = LanguageServer::VERSION
  spec.authors       = ["Fumiaki MATSUSHIMA"]
  spec.email         = ["mtsmfm@gmail.com"]

  spec.summary       = "A Ruby Language Server implementation"
  spec.description   = "A Ruby Language Server implementation"
  spec.homepage      = "https://github.com/mtsmfm/language_server-ruby"
  spec.license       = "MIT"

  spec.files         = begin
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  rescue
    Dir.glob("**/*").reject { |path| File.directory?(path) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "language_server-protocol", "0.5.0"

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "m"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-color"
  spec.add_development_dependency "minitest-power_assert"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 12.2"
  spec.add_development_dependency "selenium-webdriver"
end
