Gem::Specification.new do |s|
  s.name        = 'keylime'
  s.version     = '0.2.1'
  s.required_ruby_version = '>= 2.6'

  s.summary     = 'Simple wrapper for using Mac Keychain'
  s.description = 'Simple wrapper for using Mac Keychain'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/keylime'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split

  s.add_dependency 'ruby-keychain', '~> 0.3.0'
  s.add_dependency 'userinput', '~> 1.0.2'

  s.add_development_dependency 'fuubar', '~> 2.5.1'
  s.add_development_dependency 'goodcop', '~> 0.9.7'
  s.add_development_dependency 'rake', '~> 13.0.6'
  s.add_development_dependency 'rspec', '~> 3.12.0'
  s.add_development_dependency 'rubocop', '~> 1.54.1'
  s.metadata['rubygems_mfa_required'] = 'true'
end
