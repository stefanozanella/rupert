require 'rake/testtask'

namespace :gem do
  require "bundler/gem_tasks"
end

desc "Run all test suites"
task :test do
  Rake.application.in_namespace(:test) do |ns|
    ns.tasks.each do |task|
      task.invoke
    end
  end
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
