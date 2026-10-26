Name1: Nandish P
Roll number1: 2026203002

Name2: Dheerendra Singh 
Roll number2: 2026203017

4-bit Array Multiplier: RTL to GDSII

This repository contains the design, verification, synthesis, static timing analysis, and physical design of a 4-bit unsigned array multiplier using the SkyWater 130nm process node.

Execution Steps

The following commands were run sequentially to complete the assignment flow:

1. Environment Setup

Launched the IIC-OSIC-TOOLS Docker container with local volume mapping:

docker run -d -p 80:80 -p 5901:5901 -v ~/eda/designs:/foss/designs hpretl/iic-osic-tools



2. Part A: RTL Design and Verification

Compiled the design and testbench, ran the simulation, and viewed the waveforms:

cd /foss/designs/mult4_2026203002
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v
vvp sim
gtkwave mult.vcd



3. Part B: Logic Synthesis

Executed the Yosys synthesis script and verified the generated netlist via Gate-Level Simulation (GLS):

# Run logic synthesis
yosys -c synth/synth.tcl

# Run Gate-Level Simulation
CELLS=$PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog
iverilog -g2012 -DFUNCTIONAL -DUNIT_DELAY=#1 -o gls \
tb/tb_mult.v $CELLS/primitives.v $CELLS/sky130_fd_sc_hd.v synth/mult_array_netlist.v
vvp gls



4. Part C: Static Timing Analysis

Ran OpenSTA to calculate the minimum clock period and evaluate the critical path:

sta sta/sta.tcl



(Note: The script was executed twice; once with a 10.0 ns constraint to find WNS, and again with the calculated T_min of 2.58 ns to verify zero slack).

5. Part D: Physical Design (RTL to GDSII)

Executed the LibreLane flow to generate the physical layout and copied the final results:

cd pnr
librelane config.json

# Copy metrics and GDS layout to submission directory
cd runs/RUN_<timestamp>/final
cp metrics.json ../../../pnr/
cp gds/mult_array.gds ../../../pnr/
cd ../../../pnr

# View final physical layout
klayout mult_array.gds
