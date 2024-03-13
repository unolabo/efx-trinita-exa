module top
(
    input  io_asyncResetn,
    input  io_systemClk,
    input  io_systemClk3,
    output io_pllResetn,
    input  io_pllLocked,
    
    input  system_spi_0_io_data_0_read,
    output system_spi_0_io_data_0_write,
    output system_spi_0_io_data_0_writeEnable,
    input  system_spi_0_io_data_1_read,
    output system_spi_0_io_data_1_write,
    output system_spi_0_io_data_1_writeEnable,
    input  system_spi_0_io_data_2_read,
    output system_spi_0_io_data_2_write,
    output system_spi_0_io_data_2_writeEnable,
    input  system_spi_0_io_data_3_read,
    output system_spi_0_io_data_3_write,
    output system_spi_0_io_data_3_writeEnable,
    output system_spi_0_io_sclk_write,
    output system_spi_0_io_ss,
    
    output system_uart_0_io_txd,
    input  system_uart_0_io_rxd,
    
    output [7:0] o_led,
    input        i_sw,
    
    input  jtagCtrl_enable,
    input  jtagCtrl_tdi,
    input  jtagCtrl_capture,
    input  jtagCtrl_shift,
    input  jtagCtrl_update,
    input  jtagCtrl_reset,
    output jtagCtrl_tdo,
    input  jtagCtrl_tck
);

    `include "trinita_define.vh"
    
    wire system_spi_1_io_data_0_read;
    wire system_spi_1_io_data_0_write;
    wire system_spi_1_io_data_0_writeEnable;
    wire system_spi_1_io_data_1_read;
    wire system_spi_1_io_data_1_write;
    wire system_spi_1_io_data_1_writeEnable;
    wire system_spi_1_io_data_2_read;
    wire system_spi_1_io_data_2_write;
    wire system_spi_1_io_data_2_writeEnable;
    wire system_spi_1_io_data_3_read;
    wire system_spi_1_io_data_3_write;
    wire system_spi_1_io_data_3_writeEnable;
    wire system_spi_1_io_sclk_write;
    wire system_i2c_1_io_sda_read;
    wire system_i2c_1_io_scl_write;
    wire system_i2c_1_io_scl_read;
    wire system_i2c_1_io_sda_write;
    wire system_i2c_0_io_scl_read;
    wire system_i2c_0_io_scl_write;
    wire system_i2c_0_io_sda_read;
    wire system_i2c_0_io_sda_write;
    
    wire [0:0] system_spi_1_io_ss;
    wire [15:0] io_apbSlave_0_PADDR;
    wire io_apbSlave_0_PENABLE;
    wire [31:0] io_apbSlave_0_PRDATA;
    wire io_apbSlave_0_PREADY;
    wire io_apbSlave_0_PSEL;
    wire io_apbSlave_0_PSLVERROR;
    wire [31:0] io_apbSlave_0_PWDATA;
    wire io_apbSlave_0_PWRITE;
    wire io_systemReset;
    wire io_socReset;
    wire io_systemClk2;
    
    wire [15:0] system_gpio_0_io_writeEnable;
    wire [15:0] system_gpio_0_io_write;
    wire [15:0] system_gpio_0_io_read;
    
    
    assign io_pllResetn = io_asyncResetn;
    assign io_socReset  = ~io_pllLocked;
    assign o_led = system_gpio_0_io_write[7:0];
    assign system_gpio_0_io_read[0] = i_sw;
    assign system_gpio_0_io_read[15:1] = 0;
    assign io_systemClk2 = ~io_systemClk3;
    

    sap u_sap(
    .io_systemClk ( io_systemClk ),
    .io_systemClk2 ( io_systemClk2 ),
    .io_systemClk3 ( io_systemClk3 ),
    .jtagCtrl_enable ( jtagCtrl_enable ),
    .jtagCtrl_tdi ( jtagCtrl_tdi ),
    .jtagCtrl_capture ( jtagCtrl_capture ),
    .jtagCtrl_shift ( jtagCtrl_shift ),
    .jtagCtrl_update ( jtagCtrl_update ),
    .jtagCtrl_reset ( jtagCtrl_reset ),
    .jtagCtrl_tdo ( jtagCtrl_tdo ),
    .jtagCtrl_tck ( jtagCtrl_tck ),
    .system_spi_0_io_data_0_read ( system_spi_0_io_data_0_read ),
    .system_spi_0_io_data_0_write ( system_spi_0_io_data_0_write ),
    .system_spi_0_io_data_0_writeEnable ( system_spi_0_io_data_0_writeEnable ),
    .system_spi_0_io_data_1_read ( system_spi_0_io_data_1_read ),
    .system_spi_0_io_data_1_write ( system_spi_0_io_data_1_write ),
    .system_spi_0_io_data_1_writeEnable ( system_spi_0_io_data_1_writeEnable ),
    .system_spi_0_io_data_2_read ( system_spi_0_io_data_2_read ),
    .system_spi_0_io_data_2_write ( system_spi_0_io_data_2_write ),
    .system_spi_0_io_data_2_writeEnable ( system_spi_0_io_data_2_writeEnable ),
    .system_spi_0_io_data_3_read ( system_spi_0_io_data_3_read ),
    .system_spi_0_io_data_3_write ( system_spi_0_io_data_3_write ),
    .system_spi_0_io_data_3_writeEnable ( system_spi_0_io_data_3_writeEnable ),
    .system_spi_0_io_sclk_write ( system_spi_0_io_sclk_write ),
    .system_spi_0_io_ss ( system_spi_0_io_ss ),
    .system_spi_1_io_data_0_read ( system_spi_1_io_data_0_read ),
    .system_spi_1_io_data_0_write ( system_spi_1_io_data_0_write ),
    .system_spi_1_io_data_0_writeEnable ( system_spi_1_io_data_0_writeEnable ),
    .system_spi_1_io_data_1_read ( system_spi_1_io_data_1_read ),
    .system_spi_1_io_data_1_write ( system_spi_1_io_data_1_write ),
    .system_spi_1_io_data_1_writeEnable ( system_spi_1_io_data_1_writeEnable ),
    .system_spi_1_io_data_2_read ( system_spi_1_io_data_2_read ),
    .system_spi_1_io_data_2_write ( system_spi_1_io_data_2_write ),
    .system_spi_1_io_data_2_writeEnable ( system_spi_1_io_data_2_writeEnable ),
    .system_spi_1_io_data_3_read ( system_spi_1_io_data_3_read ),
    .system_spi_1_io_data_3_write ( system_spi_1_io_data_3_write ),
    .system_spi_1_io_data_3_writeEnable ( system_spi_1_io_data_3_writeEnable ),
    .system_spi_1_io_sclk_write ( system_spi_1_io_sclk_write ),
    .system_spi_1_io_ss ( system_spi_1_io_ss ),
    .io_apbSlave_0_PADDR ( io_apbSlave_0_PADDR ),
    .io_apbSlave_0_PENABLE ( io_apbSlave_0_PENABLE ),
    .io_apbSlave_0_PRDATA ( io_apbSlave_0_PRDATA ),
    .io_apbSlave_0_PREADY ( io_apbSlave_0_PREADY ),
    .io_apbSlave_0_PSEL ( io_apbSlave_0_PSEL ),
    .io_apbSlave_0_PSLVERROR ( io_apbSlave_0_PSLVERROR ),
    .io_apbSlave_0_PWDATA ( io_apbSlave_0_PWDATA ),
    .io_apbSlave_0_PWRITE ( io_apbSlave_0_PWRITE ),
    .io_asyncReset ( io_socReset ),
    .io_systemReset ( io_systemReset ),
    .system_uart_0_io_txd ( system_uart_0_io_txd ),
    .system_uart_0_io_rxd ( system_uart_0_io_rxd ),
    .system_i2c_1_io_sda_read ( system_i2c_1_io_sda_read ),
    .system_i2c_1_io_scl_write ( system_i2c_1_io_scl_write ),
    .system_i2c_1_io_scl_read ( system_i2c_1_io_scl_read ),
    .system_i2c_1_io_sda_write ( system_i2c_1_io_sda_write ),
    .system_i2c_0_io_scl_read ( system_i2c_0_io_scl_read ),
    .system_i2c_0_io_scl_write ( system_i2c_0_io_scl_write ),
    .system_i2c_0_io_sda_read ( system_i2c_0_io_sda_read ),
    .system_i2c_0_io_sda_write ( system_i2c_0_io_sda_write ),
    .system_gpio_0_io_writeEnable ( system_gpio_0_io_writeEnable ),
    .system_gpio_0_io_write ( system_gpio_0_io_write ),
    .system_gpio_0_io_read ( system_gpio_0_io_read )
    );
    

endmodule