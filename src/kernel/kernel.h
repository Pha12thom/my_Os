// kernel.h - Kernel header file

#ifndef KERNEL_H
#define KERNEL_H

// Define some basic types for portability
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

// Declare functions
void kernel_main(void);
void init_gdt(void);
void init_idt(void);

// Interrupt handlers
void divide_by_zero_handler(void);

// More declarations as needed...

#endif // KERNEL_H

