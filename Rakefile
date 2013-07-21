require 'rake/testtask'

namespace :gem do
  require "bundler/gem_tasks"
end

desc "Run all test suites"
task :test do
    Rake::Task['test:end_to_end'].invoke
end

namespace :test do
  Rake::TestTask.new(:end_to_end) do |t|
    t.verbose = true
    t.libs << 'lib'
    t.libs << 'test'
    t.test_files = FileList['test/end_to_end/**/*_test.rb']
  end
end
