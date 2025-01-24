# Toolchain settings
AS = nasm
LD = ld
QEMU = qemu-system-x86_64

# Directories and files
SRC_DIR = src
OBJ_DIR = build/obj
BIN_DIR = build
BOOT_BIN = $(BIN_DIR)/boot.bin
OS_IMG = $(BIN_DIR)/os.img

# Source files
BOOT_SRC = $(SRC_DIR)/boot/boot.asm

# Default target
all: $(BOOT_BIN)

# Rule to assemble the bootloader
$(BOOT_BIN): $(BOOT_SRC)
	@echo "Assembling bootloader..."
	$(AS) -f elf32 $(SRC_DIR)/boot/boot.asm -o $(OBJ_DIR)/boot.o
	$(LD) -melf_i386 -o $(BOOT_BIN) $(OBJ_DIR)/boot.o

# Rule to create a 1GB OS image
$(OS_IMG): $(BOOT_BIN)
	@echo "Creating 1GB OS image..."
	dd if=$(BOOT_BIN) of=$(OS_IMG) bs=512 seek=4
	dd if=/dev/zero of=$(OS_IMG) bs=1M seek=2 count=1024

# Clean the build directory
clean:
	@echo "Cleaning build directory..."
	rm -rf $(OBJ_DIR)/* $(BIN_DIR)/*

# Run the OS in QEMU
run: $(OS_IMG)
	@echo "Running OS in QEMU..."
	$(QEMU) -drive file=$(OS_IMG),format=raw

# Phony targets
.PHONY: all clean run

