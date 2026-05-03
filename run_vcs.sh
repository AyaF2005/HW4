#!/bin/bash
# run_vcs.sh
# Alternative compile/run script for VCS (Synopsys).
# Run from the directory containing all .sv files.

echo "=== Compiling with VCS ==="
vcs -sverilog -timescale=1ns/1ps \
    transaction_pkg.sv \
    mem_if.sv \
    my_mem.sv \
    test.sv \
    top.sv \
    -o simv

echo "=== Running simulation ==="
./simv +vcs+finish+500us

echo "=== Done ==="
