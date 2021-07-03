# frozen_string_literal: true

require_relative 'version_checker'
require 'internalobject/internalobject'
require_relative 'ruby_internal_structs'

module RubyInternal
  def get_object_address
    internal_object_id = VersionChecker.is_ruby_before_2_7 ? object_id : ObjectInternals.internal_object_id(self)
    return internal_object_id if ObjectInternals.is_primitive_object?(self)

    internal_object_id << 1
  end

  def get_pointer(*args)
    raise ArgumentError, "Can't get the pointer of a direct value" if direct_value?

    Fiddle::Pointer.new(get_object_address, *args)
  end

  def direct_value?
    [Integer, Symbol, NilClass, TrueClass, FalseClass].any? { |klass| klass == self }
  end

  # INT2FIX(i) ((VALUE)(((long)(i))<<1 | FIXNUM_FLAG))
  def int_2_fix
    raise TypeError unless is_a?(Integer)
    (self << 1) | 1
  end

  def temporally_disable_gc
    disabled_gc = !GC.disable
    yield if block_given?
  ensure
    GC.enable if disabled_gc
  end

  alias critical temporally_disable_gc

  def internal_type
    case self
    when Integer then RubyConstants::T_FIXNUM
    when Float then RubyConstants::T_FLOAT
    when NilClass then RubyConstants::T_NIL
    when FalseClass then RubyConstants::T_FALSE
    when TrueClass then RubyConstants::T_TRUE
    when Symbol then RubyConstants::T_SYMBOL
    else
      RubyInternalStructs::RBasic.new(get_pointer).flags & RubyConstants::T_MASK
    end
  end

  def internal_class
    # we use this instead of a "cleaner" method (such as a
    # hash with class => possible flags associations) because
    # (1) the number of internal types won't change
    # (2) it'd be slower
    case internal_type
    when RubyConstants::T_OBJECT
      RubyInternalStructs::RObject
    when RubyConstants::T_CLASS, RubyConstants::T_ICLASS, RubyConstants::T_MODULE
      RubyInternalStructs::RModule
    when RubyConstants::T_FLOAT
      RubyInternalStructs::RFloat
    when RubyConstants::T_STRING
      RubyInternalStructs::RString
    # when RubyInternalStructs::T_REGEXP
    #   RubyInternalStructs::RRegexp
    # when RubyInternalStructs::T_ARRAY
    #   RubyInternalStructs::RArray
    # when RubyInternalStructs::T_HASH
    #   RubyInternalStructs::RHash
    # when RubyInternalStructs::T_STRUCT
    #   RubyInternalStructs::RStruct
    # when RubyInternalStructs::T_BIGNUM
    #   RubyInternalStructs::RBignum
    # when RubyInternalStructs::T_FILE
    #   RubyInternalStructs::RFile
    # when RubyInternalStructs::T_DATA
    #   RubyInternalStructs::RData
    else
      raise "No internal class for #{self}"
    end
  end
end
