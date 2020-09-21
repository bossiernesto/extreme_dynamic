#include "ruby/ruby.h"
#include "ruby/encoding.h"

// function body
static VALUE mInternal_object_id(VALUE self, VALUE object) {
  return rb_memory_id(object);
}


void Init_internalobject(void) {
  VALUE ObjectInternals = rb_define_module("ObjectInternals");

  rb_define_singleton_method(ObjectInternals, "internal_object_id", mInternal_object_id, 1);
}