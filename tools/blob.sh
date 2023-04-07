#!/bin/bash
# Delaney Sander, 2023

# Moves into directory containing a file and then creates a linkable binary object

# Check args
if [ $# -ne 3 ]; then
  printf "Usage: %s <toolchain> <input file w/ path> <output file w/ path>\n" "$0"
  exit 1
fi

# Check that file exists
if [ ! -f "$2" ]; then
  printf "%s does not exist!\n" "$2"
  exit 1
fi

# Move to file dir and create blobject there
cd "$(dirname "$2")" || exit
"$1"ld -r -b binary -o "$(basename "$3")" "$(basename "$2")"

