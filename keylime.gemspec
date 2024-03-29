Gem::Specification.new do |s|
  s.name        = 'keylime'
  s.version     = '0.3.0'
  s.required_ruby_version = '>= 2.6'

  s.summary     = 'Simple wrapper for using Mac Keychain'
  s.description = 'Simple wrapper for using Mac Keychain'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/keylime'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split

  s.add_dependency 'ruby-keychain', '~> 0.4.0'
  s.add_dependency 'userinput', '~> 1.0.2'

  s.add_development_dependency 'goodcop', '~> 0.9.7'
  s.metadata['rubygems_mfa_required'] = 'true'
end
