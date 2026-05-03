#!/bin/bash
# run_sim.sh
# Script to compile and simulate the RAM testbench using QuestaSim.
# Run this from the directory that contains all .sv files.
#
# Usage:
#   chmod +x run_sim.sh
#   ./run_sim.sh

echo "=== Cleaning up previous build ==="
rm -rf work vsim.wlf transcript

echo "=== Creating work library ==="
vlib work

echo "=== Compiling all SV files ==="
# compile package first since others depend on it
vlog -sv transaction_pkg.sv
vlog -sv mem_if.sv
vlog -sv my_mem.sv
vlog -sv test.sv
vlog -sv top.sv

echo "=== Running simulation (500 us should be enough for 20 tests at 10MHz) ==="
vsim -c top -do "
    log -r /*;
    run 500us;
    quit -f
"

echo "=== Done. Check transcript for results ==="
