#!/usr/bin/env sh
set -e
KERNEL=zig-out/bin/kernel 

# set kernel to first argument if provided
if [ -n "$1" ]; then
  KERNEL="$1"
fi

zig build
echo "Starting QEMU with kernel: $KERNEL"
qemu-system-riscv64 \
  -machine virt \
  -m 512M \
  -bios default \
  -kernel $KERNEL\
  -nographic
