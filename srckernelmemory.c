#include "memory.h"
#include "io.h" // For displaying debug info, if needed
#include <stdbool.h>

// Memory bitmap to track used and free pages
static uint8_t memory_bitmap[BITMAP_SIZE];

// Total number of pages
static size_t total_pages = MEMORY_SIZE / PAGE_SIZE;

// Set a bit in the bitmap
static void set_bit(size_t index) {
    memory_bitmap[index / 8] |= (1 << (index % 8));
}

// Clear a bit in the bitmap
static void clear_bit(size_t index) {
    memory_bitmap[index / 8] &= ~(1 << (index % 8));
}

// Check if a bit is set in the bitmap
static bool is_bit_set(size_t index) {
    return memory_bitmap[index / 8] & (1 << (index % 8));
}

// Initialize the memory manager
void init_memory_manager() {
    // Clear the memory bitmap
    for (size_t i = 0; i < BITMAP_SIZE; i++) {
        memory_bitmap[i] = 0;
    }

    // Reserve the first few pages for the kernel
    for (size_t i = 0; i < 16; i++) {
        set_bit(i); // Mark these pages as used
    }
}

// Allocate a page of memory
void* allocate_page() {
    for (size_t i = 0; i < total_pages; i++) {
        if (!is_bit_set(i)) {
            set_bit(i);
            return (void*)(i * PAGE_SIZE);
        }
    }
    return NULL; // No free pages available
}

// Free a previously allocated page
void free_page(void* addr) {
    size_t page_index = (size_t)addr / PAGE_SIZE;

    if (page_index < total_pages && is_bit_set(page_index)) {
        clear_bit(page_index);
    } else {
        // Attempting to free an invalid or already free page
        // Add error handling if necessary
    }
}

// Display memory bitmap (for debugging)
void display_memory_bitmap() {
    for (size_t i = 0; i < total_pages; i++) {
        if (i % 32 == 0) {
            print("\n"); // Use VGA or debug output functions
        }
        print(is_bit_set(i) ? "1" : "0");
    }
}

