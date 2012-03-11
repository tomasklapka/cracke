#include <ruby.h>
#include "dma.h"

VALUE cDma = Qnil;

void Init_dma();

VALUE m_read_uint(VALUE self, VALUE address);
VALUE m_read_ulong(VALUE self, VALUE address);
VALUE m_read_float(VALUE self, VALUE address);

void Init_dma() {
    cDma = rb_define_class("Dma", rb_cObject);
    rb_define_private_method(cDma, "_read_uint", m_read_uint, 1);
    rb_define_private_method(cDma, "_read_ulong", m_read_ulong, 1);
    rb_define_private_method(cDma, "_read_float", m_read_float, 1);
}

VALUE m_read_uint(VALUE self, VALUE address) {
    uintptr_t addr = (uintptr_t) NUM2ULONG(address);
    unsigned int value = read_uint(addr);
    return UINT2NUM(value);
}

VALUE m_read_ulong(VALUE self, VALUE address) {
    uintptr_t addr = (uintptr_t) NUM2ULONG(address);
    unsigned long value = read_ulong(addr);
    return ULONG2NUM(value);
}

VALUE m_read_float(VALUE self, VALUE address) {
    uintptr_t addr = (uintptr_t) NUM2ULONG(address);
    float value = read_float(addr);
    return FLT2NUM(value);
}
