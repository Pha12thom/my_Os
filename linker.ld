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
    . = 0x100000; /* Start at 1MB */

    .text : 
    {
        *(.text)
    } >CODE

    .rodata :
    {
        *(.rodata*)
    } >RO

    .data :
    {
        *(.data)
    } >DATA

    .bss :
    {
        __bss_start = .;
        *(.bss)
        *(COMMON)
        __bss_end = .;
    } >BSS
}

