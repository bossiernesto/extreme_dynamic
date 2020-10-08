#include "ruby/ruby.h"
#include "ruby/encoding.h"

// function body
static VALUE mInternal_object_id(VALUE self, VALUE object) {
  return rb_memory_id(object);
}

static int mIs_primitive_object(VALUE self, VALUE object) {
   /*    if (STATIC_SYM_P(obj)) {
             return (SYM2ID(obj) * sizeof(RVALUE) + (4 << 2)) | FIXNUM_FLAG;
         }
         else if (FLONUM_P(obj)) {
     #if SIZEOF_LONG == SIZEOF_VOIDP
             return LONG2NUM((SIGNED_VALUE)obj);
     #else
             return LL2NUM((SIGNED_VALUE)obj);
     #endif
         }
         else if (SPECIAL_CONST_P(obj)) {
             return LONG2NUM((SIGNED_VALUE)obj);
         }
    */
   return STATIC_SYM_P(object) || FLONUM_P(object) || SPECIAL_CONST_P(object);
}

static VALUE mSymbol_to_id(VALUE self, VALUE object) {
    if STATIC_SYM_P(object){
        return (SYM2ID(object));
    }

    return Qnil;
}

void Init_internalobject(void) {
  VALUE ObjectInternals = rb_define_module("ObjectInternals");

  rb_define_singleton_method(ObjectInternals, "internal_object_id", mInternal_object_id, 1);
  rb_define_singleton_method(ObjectInternals, "is_primitive_object?", mIs_primitive_object, 1);
  rb_define_singleton_method(ObjectInternals, "symbol_to_id", mSymbol_to_id, 1);
}