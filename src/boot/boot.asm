[bits 16]                ; Specify that this code is for a 16-bit processor (real mode)
[org 0x7c00]             ; The bootloader is loaded at address 0x7c00 in memory

start:
    cli                 ; Clear interrupts (disable interrupts)
    xor ax, ax          ; Clear register AX
    mov ds, ax          ; Set DS to 0 (data segment)
    mov es, ax          ; Set ES to 0 (extra segment)

    ; Print a simple string to the screen
    mov ah, 0x0e        ; BIOS teletype output function
    mov al, 'H'         ; Character to print
    int 0x10            ; Call BIOS interrupt (video interrupt)
    mov al, 'i'
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 'O'
    int 0x10
    mov al, 'S'
    int 0x10

    ; Loop forever
hang:
    jmp hang            ; Infinite loop to keep the system running

times 510-($-$$) db 0     ; Fill the remaining space up to 510 bytes with 0s
dw 0xAA55                ; Bootloader signature (0xAA55) required by BIOS

