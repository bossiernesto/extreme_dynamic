require 'fiddle'
require 'fiddle/import'

module RubyConstants
  T_NONE     = 0x00 # < Non-object (sweeped etc.) 

  T_OBJECT   = 0x01 # < @see struct ::RObject 
  T_CLASS    = 0x02 # < @see struct ::RClass and ::rb_cClass 
  T_MODULE   = 0x03 # < @see struct ::RClass and ::rb_cModule 
  T_FLOAT    = 0x04 # < @see struct ::RFloat 
  T_STRING   = 0x05 # < @see struct ::RString 
  T_REGEXP   = 0x06 # < @see struct ::RRegexp 
  T_ARRAY    = 0x07 # < @see struct ::RArray 
  T_HASH     = 0x08 # < @see struct ::RHash 
  T_STRUCT   = 0x09 # < @see struct ::RStruct 
  T_BIGNUM   = 0x0a # < @see struct ::RBignum 
  T_FILE     = 0x0b # < @see struct ::RFile 
  T_DATA     = 0x0c # < @see struct ::RTypedData 
  T_MATCH    = 0x0d # < @see struct ::RMatch 
  T_COMPLEX  = 0x0e # < @see struct ::RComplex 
  T_RATIONAL = 0x0f # < @see struct ::RRational 

  T_NIL      = 0x11 # < @see ::Qnil 
  T_TRUE     = 0x12 # < @see ::Qfalse 
  T_FALSE    = 0x13 # < @see ::Qtrue 
  T_SYMBOL   = 0x14 # < @see struct ::RSymbol 
  T_FIXNUM   = 0x15 # < Integers formerly known as Fixnums. 
  T_UNDEF    = 0x16 # < @see ::Qundef 

  T_IMEMO    = 0x1a # < @see struct ::RIMemo 
  T_NODE     = 0x1b # < @see struct ::RNode 
  T_ICLASS   = 0x1c # < Hidden classes known as IClasses. 
  T_ZOMBIE   = 0x1d # < @see struct ::RZombie 
  T_MOVED    = 0x1e # < @see struct ::RMoved 

  T_MASK = 0x1f
  # constants

  RUBY_Qfalse = 0x00 # * ...0000 0000 */
  RUBY_Qtrue  = 0x14 # * ...0001 0100 */
  RUBY_Qnil   = 0x08 # * ...0000 1000 */
  RUBY_Qundef = 0x34 # * ...0011 0100 */

  RVALUE_size = 0x28
end

module RubyInternalStructs
  extend Fiddle::Importer

  def self.typealias(alias_type, orig_type)
    @type_alias ||= {}
    super
  end

  typealias('VALUE', 'unsigned long')
  typealias('ID', 'unsigned long')
  typealias('ulong', 'unsigned long')
  typealias('uint32_t', 'unsigned int')
  typealias('uint64_t', 'unsigned long long')

  FL_USHIFT    = 12
  FL_USER0     = 1 << (FL_USHIFT + 0)
  FL_USER1     = 1 << (FL_USHIFT + 1)
  FL_USER2     = 1 << (FL_USHIFT + 2)
  FL_USER3     = 1 << (FL_USHIFT + 3)
  FL_USER4     = 1 << (FL_USHIFT + 4)
  FL_USER5     = 1 << (FL_USHIFT + 5)
  FL_USER6     = 1 << (FL_USHIFT + 6)
  FL_USER7     = 1 << (FL_USHIFT + 7)
  FL_USER8     = 1 << (FL_USHIFT + 8)
  FL_USER9     = 1 << (FL_USHIFT + 9)
  FL_USER10     = 1 << (FL_USHIFT + 10)
  FL_USER11     = 1 << (FL_USHIFT + 11)
  FL_USER12     = 1 << (FL_USHIFT + 12)
  FL_USER13     = 1 << (FL_USHIFT + 13)
  FL_USER14     = 1 << (FL_USHIFT + 14)
  FL_USER15     = 1 << (FL_USHIFT + 15)
  FL_USER16     = 1 << (FL_USHIFT + 16)
  FL_USER17     = 1 << (FL_USHIFT + 17)
  FL_USER18     = 1 << (FL_USHIFT + 18)

  FL_SINGLETON = FL_USER0
  ELTS_SHARED = FL_USER2

  ## ruby_fl_type
  FL_WB_PROTECTED = (1<<5),
  FL_PROMOTED0    = (1<<5),
  FL_PROMOTED1    = (1<<6),
  FL_PROMOTED     = FL_PROMOTED0 || FL_PROMOTED1,
  FL_FINALIZE     = (1<<7),
  FL_TAINT        = (1<<8),
  FL_SHAREABLE    = (1<<8),
  FL_UNTRUSTED    = FL_TAINT,
  FL_SEEN_OBJ_ID  = (1<<9),
  FL_EXIVAR       = (1<<10),
  FL_FREEZE       = (1<<11),

  # The flags are based on the enum ::ruby_fl_type
  BasicStruct = [ 'VALUE flags', 'VALUE klass' ].freeze # rbasic.h@45

  # github.com/ruby/ruby/blob/92861a11633b079c9dd50599baa6841a739c741d/include/ruby/ruby.h#L865
  RBasic = struct BasicStruct

  RubyObjHeap = [
    'uint32_t numiv',
    'VALUE *ivptr',
    'st_table *iv_tbl'
  ].freeze

  RFloat = struct(BasicStruct + [
    'double value'
  ])

  RObject = struct(BasicStruct + RubyObjHeap)

  RClassStruct = [
    'rb_class_ext_t *ext',
    'st_table *m_tbl',
    'st_tble *iv_index_tbl'
  ].freeze

  RClassSuper = [
    'VALUE super',
    'st_table *iv_tbl'
  ].freeze

  RClass = struct(BasicStruct + RClassStruct)
  RModule = RClass
  RClass::Extension = struct(RClassSuper)
  RClassExtensionSize = struct(RClassSuper).size

  class RClass
    def iv_tbl
      extension.iv_tbl
    end

    def iv_tbl=(value)
      extension.iv_tbl = value
    end

    def super
      extension.super
    end

    def super=(value)
      extension.super = value
    end

    private

    def extension
      Extension.new(ext)
    end
  end
end
