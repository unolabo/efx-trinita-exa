create_clock -period 10.001 CLK
create_clock -name io_systemClk  -period 100 -waveform { 0 50.005} io_systemClk
create_clock -name io_systemClk3 -period 100 -waveform { 30.003 80.008} io_systemClk3
create_clock -name io_systemClk2 -period 100 -waveform { 70.006 20.001} io_systemClk2

# GPIO Constraints
####################


# JTAG Constraints
####################
create_clock -period 100 [get_ports {jtagCtrl_tck}]
set_output_delay -clock jtagCtrl_tck -max 0.155 [get_ports {jtagCtrl_tdo}]
set_output_delay -clock jtagCtrl_tck -min -0.053 [get_ports {jtagCtrl_tdo}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.374 [get_ports {jtagCtrl_capture}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.134 [get_ports {jtagCtrl_capture}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.374 [get_ports {jtagCtrl_reset}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.134 [get_ports {jtagCtrl_reset}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.323 [get_ports {jtagCtrl_enable}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.116 [get_ports {jtagCtrl_enable}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.374 [get_ports {jtagCtrl_update}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.134 [get_ports {jtagCtrl_update}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.449 [get_ports {jtagCtrl_shift}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.161 [get_ports {jtagCtrl_shift}]
# JTAG Constraints (extra... not used by current Efinity debug tools)
# Create separate clock groups for JTAG clocks. Remove DRCK clock from the list below if it is not defined.
set_clock_groups -asynchronous -group {jtagCtrl_tck} -group {CLK io_systemClk io_systemClk3 io_systemClk2}
