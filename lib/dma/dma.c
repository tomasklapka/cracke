#include "dma.h"

unsigned int read_uint(uintptr_t addr) { return *((unsigned int *) addr); }
unsigned long read_ulong(uintptr_t addr) { return *((unsigned long *) addr); }
float read_float(uintptr_t addr) { return *((float *) addr); }
