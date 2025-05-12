#!/bin/bash
qemu-system-x86_64 \
  -hda disk.qcow2 \
  -m 1024 \
  -smp 2 \
  -net nic \
  -net user,hostfwd=tcp::3000-:3000,hostfwd=tcp::22-:22 \
  -nographic
