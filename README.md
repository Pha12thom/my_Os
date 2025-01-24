# my_Os

## File structure

my_os/
├── docs/                     # Documentation
│   └── design.md             # OS design and architecture notes
├── src/                      # Source code
│   ├── boot/                 # Bootloader code
│   │   ├── boot.asm          # Assembly code for bootloader
│   │   ├── stage2.asm        # Second-stage bootloader (if needed)
│   ├── kernel/               # Kernel code
│   │   ├── kernel.c          # Main kernel logic
│   │   ├── kernel.h          # Kernel headers
│   │   ├── interrupts.c      # Interrupt handling
│   │   ├── interrupts.h      # Interrupt headers
│   │   ├── memory.c          # Memory management
│   │   ├── memory.h          # Memory headers
│   │   ├── io.c              # Input/output utilities
│   │   └── io.h              # IO headers
│   ├── drivers/              # Device drivers
│   │   ├── vga.c             # Basic VGA display driver
│   │   ├── keyboard.c        # Keyboard driver
│   │   └── disk.c            # Disk driver
│   ├── lib/                  # Utility libraries
│   │   ├── string.c          # Basic string manipulation functions
│   │   └── string.h          # String headers
│   └── init/                 # Initialization code
│       ├── loader.c          # OS loader logic
│       └── loader.h          # Loader headers
├── include/                  # Shared header files
│   ├── types.h               # Common data types
│   ├── macros.h              # Useful macros
│   ├── constants.h           # Global constants
│   └── config.h              # Configurations for the OS
├── build/                    # Compiled binaries and intermediate files
│   ├── kernel.bin            # Compiled kernel binary
│   ├── boot.bin              # Compiled bootloader binary
│   ├── os.img                # Bootable OS image
│   └── logs/                 # Build logs
├── tools/                    # Helper tools and scripts
│   ├── create_disk.sh        # Script to create a bootable disk image
│   ├── test_env.sh           # Script to set up testing environment
│   └── qemu_debug.sh         # Script to launch QEMU with debugging
├── tests/                    # Test cases
│   ├── kernel_tests/         # Kernel-related tests
│   ├── drivers_tests/        # Driver tests
│   └── integration/          # Integration tests
├── Makefile                  # Build automation
└── README.md                 # Project overview and instructions

