#include <stdio.h>
#include "dma.h"

int main(int argc, char **argv) {

    unsigned int _uint = 10;
    unsigned long _ulong = 100;
    float _float = 0.01;

    printf("%p %p %p\n", &_uint, &_ulong, &_float);

    unsigned int v_uint = read_uint((uintptr_t) &_uint);
    unsigned long v_ulong = read_ulong((uintptr_t) &_ulong);
    float v_float = read_float((uintptr_t) &_float);

    printf("%d %u %f\n", v_uint, v_ulong, v_float);

    _uint++;
    _ulong++;
    _float++;

    v_uint = read_uint((uintptr_t) &_uint);
    v_ulong = read_ulong((uintptr_t) &_ulong);
    v_float = read_float((uintptr_t) &_float);

    printf("%d %u %f\n", v_uint, v_ulong, v_float);

    return 0;
}