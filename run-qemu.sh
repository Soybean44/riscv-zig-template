#!/usr/bin/env sh
set -e

zig build

qemu-system-riscv64 \
  -machine virt \
  -m 512M \
  -bios default \
  -kernel zig-out/bin/kernel \
  -device virtio-gpu-pci \
  -nographic
