// kernel.c - Kernel entry point, GDT, and IDT initialization

#include "kernel.h"

// Define GDT entries
struct gdt_entry {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t  base_middle;
    uint8_t  access;
    uint8_t  limit_high;
    uint8_t  base_high;
} __attribute__((packed));

struct gdt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

struct idt_entry {
    uint16_t base_low;
    uint16_t selector;
    uint8_t  always0;
    uint8_t  flags;
    uint16_t base_high;
} __attribute__((packed));

struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

extern void gdt_flush(uint32_t);
extern void idt_flush(uint32_t);

// GDT setup
struct gdt_entry gdt[3];
struct gdt_ptr gp;

// IDT setup
struct idt_entry idt[256];
struct idt_ptr ip;

// Function to initialize the Global Descriptor Table
void init_gdt(void) {
    // Null descriptor
    gdt[0] = (struct gdt_entry){0, 0, 0, 0, 0, 0};
    
    // Code segment descriptor
    gdt[1] = (struct gdt_entry){
        0xFFFF, 0, 0, 0x9A, 0xCF, 0x00
    };
    
    // Data segment descriptor
    gdt[2] = (struct gdt_entry){
        0xFFFF, 0, 0, 0x92, 0xCF, 0x00
    };

    // Set the GDT pointer and flush the GDT
    gp.limit = sizeof(gdt) - 1;
    gp.base = (uint32_t)&gdt;
    gdt_flush((uint32_t)&gp);
}

// Function to initialize the Interrupt Descriptor Table
void init_idt(void) {
    // Set all IDT entries to 0
    for (int i = 0; i < 256; i++) {
        idt[i] = (struct idt_entry){0, 0, 0, 0, 0};
    }

    // Set up a simple handler for interrupt 0 (divide by zero)
    idt[0] = (struct idt_entry){
        (uint32_t) &divide_by_zero_handler, 0x08, 0, 0x8E, 0
    };

    // Set the IDT pointer and flush the IDT
    ip.limit = sizeof(idt) - 1;
    ip.base = (uint32_t)&idt;
    idt_flush((uint32_t)&ip);
}

// Interrupt handler for divide by zero error (interrupt 0)
void divide_by_zero_handler(void) {
    const char *error_message = "Divide by Zero Error!";
    char *video_memory = (char *) 0xb8000;

    for (int i = 0; error_message[i] != '\0'; i++) {
        video_memory[i * 2] = error_message[i];
        video_memory[i * 2 + 1] = 0x04; // Red on black
    }

    // Halting the CPU (infinite loop)
    while (1) {}
}

// Entry point for the kernel
void kernel_main(void) {
    // Initialize the GDT and IDT
    init_gdt();
    init_idt();

    // Print a simple message to the screen (VGA text mode)
    const char *message = "Hello, Kernel World!";
    char *video_memory = (char *) 0xb8000;

    for (int i = 0; message[i] != '\0'; i++) {
        video_memory[i * 2] = message[i]; // Character
        video_memory[i * 2 + 1] = 0x07;  // Color (white on black)
    }

    // Trigger a divide by zero interrupt for testing
    // This will cause the CPU to jump to the divide_by_zero_handler
    asm volatile ("int $0x00");

    // Optionally, add more kernel initialization and tests here
}

