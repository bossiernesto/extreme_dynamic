require_relative 'version_checker'
require 'internalobject/internalobject'

module RubyInternal
  #extend Fiddle::Importer

  def get_object_address
    internal_object_id = VersionChecker.is_ruby_before_2_7 ? object_id : ObjectInternals.internal_object_id(self)
    return internal_object_id if ObjectInternals.is_primitive_object?(self)

    internal_object_id << 1
  end

  #INT2FIX(i) ((VALUE)(((long)(i))<<1 | FIXNUM_FLAG))
  def int_2_fix
    raise TypeError unless self.is_a? Fixnum

    (self << 1) | 1
  end

  def temporally_disable_gc
    disabled_gc = !GC.disable
    yield if block_given?
  ensure
    GC.enable if disabled_gc
  end
  alias_method :critical, :temporally_disable_gc

end