ENV['EVERCAM_ENV'] ||= 'test'

Bundler.require(:default, :test)

# code coverage
SimpleCov.start do
  add_filter '/spec/'
end

require_relative '../lib/config'
require_relative '../lib/errors'

def require_app(name)
  require_relative "../app/#{name}"
end

def require_lib(name)
  require_relative "../lib/#{name}"
end

RSpec.configure do |c|
  c.expect_with :stdlib, :rspec
  c.filter_run_excluding skip: true
  c.mock_framework = :mocha
end

