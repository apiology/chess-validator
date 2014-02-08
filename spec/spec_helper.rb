# courtesy of:
# https://github.com/cupakromer/tao-of-tdd/blob/master/adder/spec/spec_helper.rb

require 'pathname'

module RSpec
  module_function
  def root
    @rspec_root ||= Pathname.new(__dir__)
  end
end

# Add the bin directory, to allow testing of gem executables as if the gem is
# already installed.
exec_dir = RSpec.root.join("../bin")
ENV['PATH'] = [ exec_dir, ENV['PATH'] ].join(File::PATH_SEPARATOR)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[RSpec.root.join("support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.filter_run_excluding :wip
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.alias_it_should_behave_like_to :has_behavior
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end
