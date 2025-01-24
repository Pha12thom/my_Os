# Paths
SRC_DIR := src
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
BIN_DIR := $(BUILD_DIR)/bin

# Source files
BOOT_SRC := $(SRC_DIR)/boot/boot.asm
KERNEL_SRC := $(SRC_DIR)/kernel/kernel.c
GDT_FLUSH_SRC := $(SRC_DIR)/kernel/gdt_flush.asm
IDT_FLUSH_SRC := $(SRC_DIR)/kernel/idt_flush.asm

# Output files
BOOT_BIN := $(BIN_DIR)/boot.bin
KERNEL_OBJ := $(OBJ_DIR)/kernel.o
GDT_FLUSH_OBJ := $(OBJ_DIR)/gdt_flush.o
IDT_FLUSH_OBJ := $(OBJ_DIR)/idt_flush.o
KERNEL_BIN := $(BIN_DIR)/kernel.bin
OS_IMG := $(BIN_DIR)/os.img

# Compiler and assembler
CC := gcc
ASM := nasm
LD := ld

# Flags
CFLAGS := -ffreestanding -nostdlib -nostartfiles -O2 -Wall -m32
LDFLAGS := -m elf_i386
ASMFLAGS := -f bin
OBJASMFLAGS := -f elf32

# Targets
all: $(OS_IMG)

# Create the OS image
$(OS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	@echo "Creating OS image..."
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(OS_IMG)
	dd if=/dev/zero bs=1M count=200 >> $(OS_IMG)

# Assemble the bootloader
$(BOOT_BIN): $(BOOT_SRC)
	@echo "Assembling bootloader..."
	$(ASM) $(ASMFLAGS) $< -o $@

# Compile the kernel
$(KERNEL_BIN): $(KERNEL_OBJ) $(GDT_FLUSH_OBJ) $(IDT_FLUSH_OBJ)
	@echo "Linking kernel..."
	$(LD) -T linker.ld -o $@ $^ $(LDFLAGS)

# Kernel object file
$(KERNEL_OBJ): $(KERNEL_SRC)
	@echo "Compiling kernel..."
	$(CC) $(CFLAGS) -c $< -o $@

# Assemble GDT flush
$(GDT_FLUSH_OBJ): $(GDT_FLUSH_SRC)
	@echo "Assembling GDT flush..."
	$(ASM) $(OBJASMFLAGS) $< -o $@

# Assemble IDT flush
$(IDT_FLUSH_OBJ): $(IDT_FLUSH_SRC)
	@echo "Assembling IDT flush..."
	$(ASM) $(OBJASMFLAGS) $< -o $@

# Clean build artifacts
clean:
	@echo "Cleaning build files..."
	rm -rf $(BUILD_DIR)

# Debug targets
debug: all
	qemu-system-i386 -drive format=raw,file=$(OS_IMG)

.PHONY: all clean debug

