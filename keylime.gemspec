Gem::Specification.new do |s|
  s.name        = 'keylime'
  s.version     = '0.2.1'
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.summary     = 'Simple wrapper for using Mac Keychain'
  s.description = 'Simple wrapper for using Mac Keychain'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/keylime'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_dependency 'ruby-keychain', '~> 0.3.0'
  s.add_dependency 'userinput', '~> 1.0.0'

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.5.0'
  s.add_development_dependency 'goodcop', '~> 0.8.0'
  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rubocop', '~> 0.76.0'
end
