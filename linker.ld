/* Define memory layout */
ENTRY(kernel_main) /* Entry point function */

/* Specify the start address of the kernel */
SECTIONS {
    /* Set the entry point for the kernel */
    . = 0x100000; /* The kernel is loaded at address 1MB */

    /* .text section: Contains the actual code of the kernel */
    .text : {
        *(.text) /* All text (code) sections from object files */
    } > CODE

    /* .data section: Contains initialized data */
    .data : {
        *(.data) /* All data sections from object files */
    } > DATA

    /* .bss section: Contains uninitialized data */
    .bss : {
        *(.bss) /* All bss sections from object files */
    } > BSS

    /* .rodata section: Contains read-only data */
    .rodata : {
        *(.rodata)
    } > RO

    /* Stack setup (non-executable stack) */
    .note.GNU-stack 0 : { *(.note.GNU-stack) }

    /* Provide memory protection settings (no RWX segments) */
    PROVIDE(__stack_start = .);
}

