require 'rake/testtask'
require 'coveralls/rake/task'

namespace :gem do
  require "bundler/gem_tasks"
end

Rake::TestTask.new do |t|
  t.verbose = true
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
end

namespace :test do
  %w{end_to_end unit}.each do |suite|
    Rake::TestTask.new(suite.to_sym) do |t|
      t.verbose = true
      t.libs << 'lib'
      t.libs << 'test'
      t.test_files = FileList["test/#{suite}/**/*_test.rb"]
    end
  end
end
