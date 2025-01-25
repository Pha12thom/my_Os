# Compiler and tools
ASM = nasm
CC = gcc
LD = ld
QEMU = qemu-system-i386

# Build flags
CFLAGS = -ffreestanding -nostdlib -nostartfiles -O2 -Wall -m32
LDFLAGS = -m elf_i386 -T linker.ld
ASMFLAGS = -f bin
ASM_OBJ_FLAGS = -f elf32

# Directories
SRC_DIR = src
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin
INCLUDE_DIR = include

# Files
BOOTLOADER_SRC = $(SRC_DIR)/boot/boot.asm
KERNEL_SRC = $(SRC_DIR)/kernel/kernel.c
MEMORY_SRC = $(SRC_DIR)/kernel/memory.c
GDT_FLUSH_SRC = $(SRC_DIR)/kernel/gdt_flush.asm
IDT_FLUSH_SRC = $(SRC_DIR)/kernel/idt_flush.asm

BOOTLOADER_BIN = $(BIN_DIR)/boot.bin
KERNEL_OBJ = $(OBJ_DIR)/kernel.o
MEMORY_OBJ = $(OBJ_DIR)/memory.o
GDT_FLUSH_OBJ = $(OBJ_DIR)/gdt_flush.o
IDT_FLUSH_OBJ = $(OBJ_DIR)/idt_flush.o
KERNEL_BIN = $(BIN_DIR)/kernel.bin
OS_IMG = $(BIN_DIR)/os.img

# Targets
all: $(OS_IMG)

$(OS_IMG): $(BOOTLOADER_BIN) $(KERNEL_BIN)
        @echo "Creating OS image..."
        cat $^ > $@
        dd if=/dev/zero bs=512 count=1 >> $@ # Pad the image to 512 bytes

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
        @echo "Assembling bootloader..."
        $(ASM) $(ASMFLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ) $(MEMORY_OBJ) $(GDT_FLUSH_OBJ) $(IDT_FLUSH_OBJ)
        @echo "Linking kernel..."
        $(LD) $(LDFLAGS) -o $@ $^

$(KERNEL_OBJ): $(KERNEL_SRC)
        @echo "Compiling kernel..."
        $(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(MEMORY_OBJ): $(MEMORY_SRC)
        @echo "Compiling memory manager..."
        $(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(GDT_FLUSH_OBJ): $(GDT_FLUSH_SRC)
        @echo "Assembling GDT flush..."
        $(ASM) $(ASM_OBJ_FLAGS) $< -o $@

$(IDT_FLUSH_OBJ): $(IDT_FLUSH_SRC)
        @echo "Assembling IDT flush..."
        $(ASM) $(ASM_OBJ_FLAGS) $< -o $@

clean:
        @echo "Cleaning build files..."
        rm -rf $(BUILD_DIR)

run: $(OS_IMG)
        @echo "Running OS in QEMU..."
        $(QEMU) -drive format=raw,file=$<

debug: $(OS_IMG)
        @echo "Running OS in QEMU with GDB debugging..."
        $(QEMU) -drive format=raw,file=$< -s -S

.PHONY: all clean run debug

