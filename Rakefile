require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task docs: "docs:server" do
end

namespace :docs do
  desc "run live docs server on http://localhost:8808"
  task :server do
    exec("yard server --reload")
  end

  desc "list undocumented files"
  task :stats do
    exec("yard stats --list-undoc")
  end
end

task default: :test
