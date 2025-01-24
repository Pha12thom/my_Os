global gdt_flush
gdt_flush:
    mov eax, [esp+4]
    lgdt [eax]
    ret

