class VersionChecker
  RUBY_2_7 = '2.7.0'

  def self.is_ruby_before_2_7
    Gem::Version.new(RUBY_VERSION) < Gem::Version.new(RUBY_2_7)
  end
end