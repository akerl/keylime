if ENV['CI'] == 'true'
  require 'simplecov'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rspec'
$LOAD_PATH.unshift File.expand_path('stub', __dir__)
require 'keylime'
