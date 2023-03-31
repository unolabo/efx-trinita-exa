create_clock -period 40.0000 io_systemClk2
create_clock -waveform {15.0000 35.0000} -period 40.0000 io_systemClk

# GPIO Constraints
####################
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {io_asyncResetn}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {io_asyncResetn}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {my_pll_refclk}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {my_pll_refclk}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {system_uart_0_io_rxd}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {system_uart_0_io_rxd}]
set_output_delay -clock io_systemClk -max -3.500 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock io_systemClk -min -2.139 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock io_systemClk -max -3.500 [get_ports {system_spi_0_io_ss}]
set_output_delay -clock io_systemClk -min -2.139 [get_ports {system_spi_0_io_ss}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {system_uart_0_io_txd}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {system_uart_0_io_txd}]
set_input_delay -clock io_systemClk -max 4.968 [get_ports {system_spi_0_io_data_0_read}]
set_input_delay -clock io_systemClk -min 2.484 [get_ports {system_spi_0_io_data_0_read}]
set_output_delay -clock io_systemClk -max -3.500 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock io_systemClk -min -2.139 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock io_systemClk -max -3.507 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_output_delay -clock io_systemClk -min -2.143 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_input_delay -clock io_systemClk -max 4.968 [get_ports {system_spi_0_io_data_1_read}]
set_input_delay -clock io_systemClk -min 2.484 [get_ports {system_spi_0_io_data_1_read}]
set_output_delay -clock io_systemClk -max -3.500 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock io_systemClk -min -2.139 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock io_systemClk -max -3.507 [get_ports {system_spi_0_io_data_1_writeEnable}]
set_output_delay -clock io_systemClk -min -2.143 [get_ports {system_spi_0_io_data_1_writeEnable}]

# JTAG Constraints
####################
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst1_TCK}]
set_output_delay -clock jtag_inst1_TCK -max 0.111 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtag_inst1_TCK -min -0.053 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.231 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.116 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.321 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.161 [get_ports {jtag_inst1_SHIFT}]
