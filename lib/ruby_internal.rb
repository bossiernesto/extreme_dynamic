require_relative 'version_checker'
require 'internalobject/internalobject'

module RubyInternal
  #extend Fiddle::Importer

  def get_object_address
    if VersionChecker.is_ruby_before_2_7
      return object_id << 1
    end
    ObjectInternals.internal_object_id(self) << 1
  end

  def temporally_disable_gc
    disabled_gc = !GC.disable
    yield if block_given?
  ensure
    GC.enable if disabled_gc
  end
  alias_method :critical, :temporally_disable_gc

end