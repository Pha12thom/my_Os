#include "memory.h"

void kernel_main() {
    init_memory_manager();
    void* page = allocate_page();
    free_page(page);
}

