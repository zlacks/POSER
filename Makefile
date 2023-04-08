# Delaney Sander | dts487 | 11086571

# USAGE
#   make                         build kernel
#   make ARCH=arm-realview-qemu  build kernel for QEMU Realview board (default)
#   make TOOLCHAIN=ab-cd-ef-     build kernel w/ custom toolchain
#   make CPU=cortex-a8			 build kernel for cortex-a8 CPU       (default)
#   make DEF=somemacro           build kernel w/ preproc macro defined
#   make qemu                    build kernel and run QEMU 
#   make qemu-gdb                build kernel and run QEMU w/ gdb port 30486
#   make GDBPORT=1234 qemu-gdb   build kernel and run QEMU w/ gdb port 1234
#	make dump					 dump kernel assembly contents
#   make layout					 show kernel symbol layout
#
# Any source files added to the ./src or ./arch/$(ARCH)/src folder will 
# automatically be compiled and linked to kernel.elf. Addtional rules must be 
# added to activate rebuilds when prerequisite header files are edited. 

# -----------------------------------------------------------------------------
# DIRECTORIES AND FILES
# -----------------------------------------------------------------------------
# Which architecture directories to use 
ARCH ?= arm-realview-qemu

# Kernel directory names
SRC = src
INC = include
OBJ = obj
BIN = bin

ARCH-SRC = arch/$(ARCH)/src
ARCH-INC = arch/$(ARCH)/include

# User program directory names
USER  = user
U-OBJ = $(USER)/obj
U-BIN = $(USER)/bin

# Kernel source and header files are discovered in their respective dirs
C-SRCS      := $(wildcard $(SRC)/*.c) 
C-ARCH-SRCS := $(wildcard $(ARCH-SRC)/*.c)
A-SRCS      := $(wildcard $(SRC)/*.S)
A-ARCH-SRCS := $(wildcard $(ARCH-SRC)/*.S)
INCS        := $(wildcard $(INC)/*.h) $(wildcard $(ARCH-INC)/*.h)

# Kernel object file names are generated from discovered source file names
C-OBJS := $(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(C-SRCS)) $(patsubst $(ARCH-SRC)/%.c,$(OBJ)/%.o,$(C-ARCH-SRCS))
A-OBJS := $(patsubst $(SRC)/%.S,$(OBJ)/%.o,$(A-SRCS)) $(patsubst $(ARCH-SRC)/%.S,$(OBJ)/%.o,$(A-ARCH-SRCS))

# Kernel .bin and .img names are generated from the .elf name
KERNEL-ELF  = $(BIN)/kernel.elf

# User program names are generated from .c files in $(USER)/
U-BINS := $(patsubst $(USER)/%.c,$(U-BIN)/%.blob,$(wildcard $(USER)/*.c))

# All user progs are linked to these "libraries"
U-LIBS =

# -----------------------------------------------------------------------------
# COMPILERS AND FLAGS
# -----------------------------------------------------------------------------
TOOLCHAIN ?= arm-none-eabi-
AS = $(TOOLCHAIN)as
CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)ld
OC = $(TOOLCHAIN)objcopy
NM = $(TOOLCHAIN)nm -nf sysv
BL = ./tools/blob.sh

CPU    ?= cortex-a8
DEF    ?= NONE
AFLAGS  = -mcpu=cortex-a8 -g
CFLAGS  = -Wall -Wextra -Winline -pedantic -std=c99 -g -fPIE -mfloat-abi=hard \
		  -mcpu=$(CPU) -nostartfiles -ffreestanding -fno-omit-frame-pointer -D $(DEF)
LDFLAGS = -nostdlib
LIBS    = -lgcc 

# -----------------------------------------------------------------------------
# QEMU
# -----------------------------------------------------------------------------
QEMU     = qemu-system-arm
QEMUOPTS = -m 512M \
			-M realview-pb-a8 \
			-cpu cortex-a8 \
			-nographic
GDBPORT ?= 30432

# -----------------------------------------------------------------------------
# TARGETS
# -----------------------------------------------------------------------------
.PHONY: kernel qemu qemu-gdb dump layout clean deepclean
kernel: $(KERNEL-ELF)

# Link all .o files using qboot.ld linker script, create bin/ if necessary
# User files are linked in as "blobjects" that are accessible via symbols
# Prints a symbols dump for checking memory layout
$(KERNEL-ELF): $(ARCH-SRC)/kernel.ld $(A-OBJS) $(C-OBJS) $(U-BINS) | $(BIN)
	$(CC) $(LDFLAGS) -T  $^ -o $@ $(LIBS)
	@$(NM) $@

# Compile all kernel .c files in $(SRC) into respective .o files, create $(OBJ)
# dir if necessary
$(OBJ)/%.o: $(SRC)/%.c | $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@ -I$(INC) -I$(ARCH-INC)

# Compile all kernel .c files in $(ARCH-SRC) into respective .o files, create $(OBJ)
# dir if necessary
$(OBJ)/%.o: $(ARCH-SRC)/%.c | $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@ -I$(INC) -I$(ARCH-INC)

# Compile all kernel .S files in $(SRC) into respective .o files, create $(OBJ) 
# dir if necessary
$(OBJ)/%.o: $(SRC)/%.S | $(OBJ)	
	$(AS) $(AFLAGS) $< -o $@

# Compile all kernel .S files in $(ARCH-SRC) into respective .o files, create $(OBJ) 
# dir if necessary
$(OBJ)/%.o: $(ARCH-SRC)/%.S | $(OBJ)	
	$(AS) $(AFLAGS) $< -o $@

# Transform user program assembly into a binary "blobject" for linking w/ kernel
$(U-BIN)/%.blob: $(U-BIN)/%.bin
	$(BL) $(TOOLCHAIN) $< $@
	@printf "\nSymbol reference for %s:\n" "$@"
	@objdump -x $@

# Strip .elf data and covert to raw assembly
$(U-BIN)/%.bin: $(U-BIN)/%.elf
	$(OC) -O binary $< $@

# Creates user program by linking w/ object of matching name
$(U-BIN)/%.elf: $(U-OBJ)/%.o $(USER)/$(ARCH)-user.ld $(U-LIBS) | $(U-BIN)
	$(CC) $(LDFLAGS) -T $(USER)/$(ARCH)-user.ld -o $@ $< $(U-LIBS) -lgcc
	@$(NM) $@

# Compile all USER .c files into respective .o files, create obj/ if necessary
$(U-OBJ)/%.o: $(USER)/%.c | $(U-OBJ)
	$(CC) $(CFLAGS) -c $< -o $@ -I$(INC) -I$(ARCH-INC)

.PRECIOUS: $(U-BIN)/%.elf $(U-OBJ)/%.o $(U-BIN)/%.blob

# Prerequisite headers and special cases go below here ----------
# Only rule is required, no recipe. Recipes for compiling/linking are covered by
# pattern matching rules 

$(OBJ)/kernel.o: $(INCS) 

# Build directories ---------------------------------------------
$(OBJ) $(BIN) $(U-OBJ) $(U-BIN):
	@mkdir -v $@

# Housekeeping --------------------------------------------------
clean:
	rm -rf $(OBJ)
	rm -rf $(U-OBJ)

deepclean: clean
	rm -rf $(BIN)
	rm -rf $(U-BIN)

# -----------------------------------------------------------------------------
# DIRECTORIES AND FILES
# -----------------------------------------------------------------------------

# Build kernel and run QEMU 
qemu: $(KERNEL-ELF)
	@printf "Starting QEMU...\n\n"
	@$(QEMU) $(QEMUOPTS) -kernel $(KERNEL-ELF) 2>> errlog.txt

# Build kernel and run QEMU w/ remote GDB enabled
qemu-gdb: $(KERNEL-ELF)
	@echo "Starting QEMU..."
	@echo "---------------------"
	@echo "Attach 'arm-none-eabi-gdb' or 'gdb-multiarch' to continue"
	@echo "To attach, enter the following in gdb:"
	@echo "  > target remote localhost:$(GDBPORT)"
	@echo "  > file $(KERNEL-ELF)"
	@echo "---------------------"
	@$(QEMU) $(QEMUOPTS) -kernel $(KERNEL-ELF) -gdb tcp::$(GDBPORT) -S 2>> errlog.txt

# Dump kernel assembly code
dump: $(KERNEL-ELF)
	@$(TOOLCHAIN)objdump -S --visualize-jumps=color -w $(KERNEL-ELF)

# Show layout of kernel segments and symbols
layout: $(KERNEL-ELF)
	@$(NM) $(KERNEL-ELF)
