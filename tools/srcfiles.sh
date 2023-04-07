#!/bin/bash

# List .c, .S, .ld, and .h files
find . -regextype posix-extended -regex ".*\.(c|S|ld|h)$"

