#Rakefile
require "bundler/gem_tasks"
require "rake/extensiontask"

spec = Gem::Specification.load('extreme_dynamic.gemspec')

Rake::ExtensionTask.new("internalobject", spec) do |ext|
  ext.lib_dir = "lib/internalobject"
end
