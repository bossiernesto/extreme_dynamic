Gem::Specification.new do |spec|
  spec.name     = "extreme_dynamic"
  spec.summary  = "Just doing some prohibited things"
  spec.version  = "0.1.0"
  spec.authors  = %w(Ernesto Bossi)

  spec.required_ruby_version = "> 2.5"
  spec.files = `git ls-files`.split("\n")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.extensions = %w(ext/internalobject/extconf.rb)
  spec.require_paths = %w(lib ext)
end