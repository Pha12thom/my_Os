
---

# My Operating System

This is a simple operating system developed from scratch. The project aims to provide an in-depth understanding of OS development, from the bootloader to the kernel and device drivers. Written in **C**, the OS features a bootloader, kernel logic, device drivers, memory management, and more.

## Project Structure

```
my_os/
├── docs/                         # Documentation
│   └── design.md                 # OS design and architecture notes
├── src/                          # Source code
│   ├── boot/                     # Bootloader code
│   │   └── boot.asm              # Assembly code for bootloader
│   ├── kernel/                   # Kernel code
│   │   ├── kernel.c              # Main kernel logic
│   │   ├── kernel.h              # Kernel headers
│   │   ├── interrupts.c          # Interrupt handling
│   │   ├── interrupts.h          # Interrupt headers
│   │   ├── memory.c              # Memory management
│   │   ├── memory.h              # Memory headers
│   │   ├── io.c                  # Input/output utilities
│   │   ├── io.h                  # IO headers
│   │   ├── gdt_flush.asm         # GDT flushing code
│   │   ├── idt_flush.asm         # IDT flushing code
│   ├── drivers/                  # Device drivers
│   │   ├── vga.c                 # Basic VGA display driver
│   │   ├── keyboard.c            # Keyboard driver
│   │   └── disk.c                # Disk driver
│   ├── lib/                      # Utility libraries
│   │   ├── string.c              # Basic string manipulation functions
│   │   └── string.h              # String headers
│   └── init/                     # Initialization code
│       ├── loader.c              # OS loader logic
│       └── loader.h              # Loader headers
├── include/                      # Shared header files
│   ├── types.h                   # Common data types
│   ├── macros.h                  # Useful macros
│   ├── constants.h               # Global constants
│   └── config.h                  # Configurations for the OS
├── build/                        # Compiled binaries and intermediate files
│   ├── obj/                      # Object files (compiled .o files)
│   │   ├── kernel.o              # Kernel object file
│   │   ├── gdt_flush.o           # GDT flush object file
│   │   └── idt_flush.o           # IDT flush object file
│   ├── bin/                      # Binary files
│   │   ├── boot.bin              # Bootloader binary
│   │   ├── kernel.bin            # Compiled kernel binary
│   │   └── os.img                # OS image (bootable)
│   └── logs/                     # Build logs
├── tools/                        # Helper tools and scripts
│   ├── create_disk.sh            # Script to create a bootable disk image
│   ├── test_env.sh               # Script to set up testing environment
│   └── qemu_debug.sh             # Script to launch QEMU with debugging
├── tests/                        # Test cases
│   ├── kernel_tests/             # Kernel-related tests
│   ├── drivers_tests/            # Driver tests
│   └── integration/              # Integration tests
├── Makefile                      # Build automation
└── README.md                     # Project overview and instructions
```

### **Project Overview**

This operating system is designed to provide an understanding of:
- **Bootloaders**: Starting the machine and loading the kernel.
- **Kernel Development**: Managing hardware, memory, processes, and I/O.
- **Device Drivers**: Interfacing with devices like VGA displays, keyboards, and disks.
- **Utility Libraries**: Handling strings and system utilities.
- **Testing**: Ensuring kernel, drivers, and integrations work correctly.

The project is **written in C**, but some assembly is used in the bootloader for initialization. The kernel includes code for interrupt handling, memory management, and I/O functionality. Device drivers interact with the hardware, while the initialization code boots and loads the system.

### **Components**

- **Bootloader (`src/boot/`)**: This directory contains the bootloader code. It is responsible for loading the kernel into memory when the system starts. The `boot.asm` file contains the assembly language for the initial bootloader. If needed, `stage2.asm` handles additional boot stages.

- **Kernel (`src/kernel/`)**: The kernel directory contains code for the core functionalities of the OS:
  - **Interrupt Handling**: Managing CPU interrupts and exceptions.
  - **Memory Management**: Handling memory allocation, paging, and heap management.
  - **I/O Management**: Providing functionality to interact with input/output devices.

- **Drivers (`src/drivers/`)**: The drivers directory includes device drivers:
  - **VGA Driver**: Provides basic screen display capabilities.
  - **Keyboard Driver**: Handles keyboard input.
  - **Disk Driver**: Manages disk operations, like reading and writing.

- **Lib (`src/lib/`)**: Utility libraries for common operations, such as string manipulation.

- **Initialization (`src/init/`)**: The initialization code that sets up the system, prepares the environment for the kernel, and begins the OS startup.

- **Header Files (`include/`)**: Shared headers used across the codebase. This includes:
  - **Types**: Defines common types (e.g., `uint32_t`).
  - **Macros**: Useful macros that simplify code and improve readability.
  - **Constants**: Global constants like screen size or memory addresses.
  - **Config**: Configuration settings that can be adjusted for different environments.

- **Build Directory (`build/`)**: Contains compiled binaries and OS image files:
  - **kernel.bin**: The compiled kernel binary.
  - **boot.bin**: The bootloader binary.
  - **os.img**: The bootable OS image file that can be run in QEMU or a virtual machine.

- **Tools (`tools/`)**: Scripts to help automate processes:
  - **create_disk.sh**: Creates a bootable disk image.
  - **test_env.sh**: Sets up the environment for testing.
  - **qemu_debug.sh**: Launches QEMU with debugging options.

- **Tests (`tests/`)**: Unit tests and integration tests to ensure correctness:
  - **kernel_tests**: Tests for kernel functionality.
  - **drivers_tests**: Tests for device drivers.
  - **integration**: End-to-end tests to ensure components work together.

### **Building and Running the OS**

#### Prerequisites

Ensure you have the following tools installed on your system:
- **GCC/Clang**: For compiling C/C++ code.
- **NASM**: For assembling the bootloader.
- **QEMU**: For virtual machine execution.

#### Build Instructions

To build the OS from source:
1. Install dependencies:
   ```bash
   sudo apt-get install build-essential nasm qemu
   ```

2. Build the OS:
   ```bash
   make
   ```

3. After building, you can run the OS in QEMU:
   ```bash
   qemu-system-x86_64 -drive file=build/os.img,format=raw
   ```

#### Creating a Bootable Disk

Use the `create_disk.sh` script to generate a bootable disk image:
```bash
./tools/create_disk.sh
```

### **Testing**

To run tests:
1. Set up the testing environment:
   ```bash
   ./tools/test_env.sh
   ```

2. Run the kernel and driver tests:
   ```bash
   make test
   ```

3. Integration tests:
   ```bash
   make integration
   ```

### **Contributing**

Contributions are welcome! You can:
- Submit bug fixes or enhancements.
- Add more drivers, features, or utilities.
- Contribute to documentation or improve tests.

Fork the repository, make your changes, and create a pull request.

### **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

This README covers the entire project structure and provides instructions on building, running, and testing your OS.
