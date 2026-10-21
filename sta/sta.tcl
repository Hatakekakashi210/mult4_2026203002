set lib $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_liberty $lib
read_verilog synth/mult_array_netlist.v
link_design mult_array

# Virtual clock: no port, just a timing reference
create_clock -name clk -period 2.58 [get_ports clock]

set_input_delay  1.0 -clock clk [delete_from_list [all_inputs] [get_ports clock]]
set_output_delay 1.0 -clock clk [all_outputs]

report_worst_slack -max
report_checks -path_delay max -digits 3 > sta/mult_array_timing.rpt
