require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  task.output_dir = 'metrics'
end

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = '--format doc'
end

desc 'Default: Run specs.'
task default: [ :spec ]
