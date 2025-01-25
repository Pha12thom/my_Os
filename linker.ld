ENTRY(_start)

MEMORY
{
    CODE : ORIGIN = 0x100000, LENGTH = 512K
    RO   : ORIGIN = 0x180000, LENGTH = 128K
    DATA : ORIGIN = 0x1A0000, LENGTH = 128K
    BSS  : ORIGIN = 0x1C0000, LENGTH = 128K
}

SECTIONS
{
    /* Set the starting address of the binary */
    . = 0x100000;

    /* Code Section */
    .text :
    {
        _start = .;                /* Entry point */
        *(.text)                   /* All .text sections */
        *(.text.*)                 /* All .text.* sections */
    } >CODE

    /* Read-Only Data Section */
    .rodata :
    {
        *(.rodata)                 /* All .rodata sections */
        *(.rodata.*)               /* All .rodata.* sections */
    } >RO

    /* Data Section */
    .data :
    {
        *(.data)                   /* All .data sections */
        *(.data.*)                 /* All .data.* sections */
    } >DATA

    /* BSS Section */
    .bss :
    {
        __bss_start = .;           /* Start of BSS */
        *(.bss)                    /* All .bss sections */
        *(COMMON)                  /* COMMON symbols */
        __bss_end = .;             /* End of BSS */
    } >BSS

    /* Optional Bitmap Section for Memory Manager */
    .bitmap ALIGN(0x1000) :
    {
        *(.bitmap)                 /* All .bitmap sections */
    } >DATA

    /* Stack Section (optional, if needed) */
    .stack ALIGN(0x1000) :
    {
        *(.stack)
    } >DATA
}

