lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'

if RUBY_VERSION < '2.0.0'
  require 'vnstat-metrics'
else
  require_relative 'lib/vnstat-metrics'
end

Gem::Specification.new do |s|
  s.authors                = ['Dan Pisarski']
  s.description            = 'Sensu plugins for traffic metrics using vnstat'
  s.email                  = 'me@danpisarski.com'
  s.executables            = Dir.glob('bin/**/*').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w(LICENSE.md README.md)
  s.homepage               = 'http://github.com/danpisarski/vnstat-metrics'
  s.license                = 'MIT'
  s.name                   = 'vnstat-metrics'
  s.platform               = Gem::Platform::RUBY
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 1.9.3'
  s.summary                = 'Sensu plugins for traffic metrics using vnstat'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = VnstatMetrics::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '1.2.0'

  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'rake',                      '~> 10.0'
end
