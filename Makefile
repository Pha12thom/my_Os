# Compiler settings
CC = gcc
AS = nasm
LD = ld
CFLAGS = -ffreestanding -nostdlib -nostartfiles -O2 -Wall
LDFLAGS = -T linker.ld -ffreestanding -O2

# Directories
SRC_DIR = src
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin
IMG_DIR = $(BUILD_DIR)/img
TOOLS_DIR = tools
TEST_DIR = tests

# Files
BOOT_ASM = $(SRC_DIR)/boot/boot.asm
BOOT_BIN = $(BIN_DIR)/boot.bin
OS_IMG = $(IMG_DIR)/os.img
KERNEL_C = $(SRC_DIR)/kernel/kernel.c
KERNEL_OBJ = $(OBJ_DIR)/kernel.o
KERNEL_BIN = $(BIN_DIR)/kernel.bin
GDT_FLUSH_ASM = src/boot/gdt_flush.asm
IDT_FLUSH_ASM = src/boot/idt_flush.asm
LINKER_SCRIPT = linker.ld

# Make the directories
$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR) $(IMG_DIR) $(BUILD_DIR)/logs)

# Default target
all: $(OS_IMG)

# Compile bootloader
$(BOOT_BIN): $(BOOT_ASM)
	@echo "Assembling bootloader..."
	$(AS) -f bin $(BOOT_ASM) -o $(BOOT_BIN)

# Compile kernel
$(KERNEL_OBJ): $(KERNEL_C)
	@echo "Compiling kernel..."
	$(CC) $(CFLAGS) -c $(KERNEL_C) -o $(KERNEL_OBJ)

# Link the kernel
$(KERNEL_BIN): $(KERNEL_OBJ)
	@echo "Linking kernel..."
	$(LD) $(LDFLAGS) -o $(KERNEL_BIN) $(KERNEL_OBJ) -m elf_i386

# Build the final OS image
$(OS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	@echo "Building OS image..."
	# Create empty image file of 200MB (change size as needed)
	dd if=/dev/zero of=$(OS_IMG) bs=1M seek=2 count=200
	# Copy bootloader to the start of the image
	dd if=$(BOOT_BIN) of=$(OS_IMG) bs=512 seek=4
	# Copy the kernel to the image
	dd if=$(KERNEL_BIN) of=$(OS_IMG) bs=512 seek=200

# Clean up build files
clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)

# Test running QEMU
run: $(OS_IMG)
	@echo "Running OS in QEMU..."
	qemu-system-x86_64 -drive format=raw,file=$(OS_IMG)

# Debugging (optional)
debug: $(OS_IMG)
	@echo "Running OS in QEMU with debugging enabled..."
	qemu-system-x86_64 -drive format=raw,file=$(OS_IMG) -s -S

# Rebuild everything
rebuild: clean all

