#!/bin/bash

# Assembly dump and .elf file w/ all the fixin's
arm-none-eabi-objdump -S --visualize-jumps=color --disassembler-color=color "$1"
