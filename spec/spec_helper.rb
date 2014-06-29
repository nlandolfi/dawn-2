
ENV["RACK_ENV"] = "test"

require_relative "../dawn.rb"

Bundler.require(:test)

SimpleCov.coverage_dir ENV["COVERAGE_PATH"] || "/tmp/coverage"

# Only generate coverage on demand
# e.g., $ COVERAGE=true bundle exec rspec spec
SimpleCov.start do

  # add_group "Routes", "/app/routes"

end if ENV["COVERAGE"]

RSpec.configure do |config|

  config.color = true

end

