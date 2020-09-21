require 'fiddle'
require 'fiddle/import'
require 'internalobject/internalobject'

module RubyConstants
  T_NONE   = 0x00
  T_NIL    = 0x01
  T_OBJECT = 0x02
  T_CLASS  = 0x03
  T_A = 0x04
  T_MODULE = 0x05
  T_FLOAT  = 0x06
  T_STRING = 0x07
  T_REGEXP = 0x08
  T_ARRAY  = 0x09
  T_FIXNUM = 0x0a
  T_HASH   = 0x0b
  T_STRUCT = 0x0c
  T_BIGNUM = 0x0d
  T_FILE   = 0x0e

  T_TRUE   = 0x10
  T_FALSE  = 0x11
  T_DATA   = 0x12
  T_MATCH  = 0x13
  T_SYMBOL = 0x14

  T_BLOCK  = 0x1b
  T_UNDEF  = 0x1c
  T_VARMAP = 0x1d
  T_SCOPE  = 0x1e
  T_NODE   = 0x1f

  T_MASK   = 0x1f
    # constants
end

class VersionChecker
  RUBY_2_7 = '2.7.0'

  def self.is_ruby_before_2_7
    Gem::Version.new(RUBY_VERSION) < Gem::Version.new(RUBY_2_7)
  end
end


module RubyInternal
  #extend Fiddle::Importer

  def get_object_address
    if VersionChecker.is_ruby_before_2_7
      return object_id << 1
    end
    ObjectInternals.internal_object_id(self) << 1
  end

end

class Integer
  def ptr2ref
    if self % 4 == 0
      Fiddle::Pointer.new(self).to_i
    else
      raise ArgumentError, 'invalid as a pointer'
    end
  end
end

#RBasic
#https://github.com/ruby/ruby/blob/92861a11633b079c9dd50599baa6841a739c741d/include/ruby/ruby.h#L865