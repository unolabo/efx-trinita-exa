module top
(
    input  io_asyncResetn,
    input  CLK125M,
    output io_pllResetn,
    input  io_pllLocked,
    input  pushsw,
    
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
    output [0:0] system_spi_0_io_ss,
    
    output system_uart_0_io_txd,
    input  system_uart_0_io_rxd,
    
    input  i2c_1_io_sda_read ,
    output i2c_1_io_scl_write,
    output i2c_1_io_scl_writeEnable,
    input  i2c_1_io_scl_read ,
    output i2c_1_io_sda_write,
    output i2c_1_io_sda_writeEnable,
    input  i2c_0_io_scl_read ,
    output i2c_0_io_scl_write,
    output i2c_0_io_scl_writeEnable,
    input  i2c_0_io_sda_read ,
    output i2c_0_io_sda_write,
    output i2c_0_io_sda_writeEnable,
    
    output [1:0] o_led,
    
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
    
    wire io_systemReset;
    wire io_socReset;
    wire [15:0] system_gpio_0_io_writeEnable;
    wire [15:0] system_gpio_0_io_write;
    wire [15:0] system_gpio_0_io_read;
    wire system_i2c_1_io_sda_read ;
    wire system_i2c_1_io_scl_write;
    wire system_i2c_1_io_scl_read ;
    wire system_i2c_1_io_sda_write;
    wire system_i2c_0_io_scl_read ;
    wire system_i2c_0_io_scl_write;
    wire system_i2c_0_io_sda_read ;
    wire system_i2c_0_io_sda_write;
    reg  reg_spi_0_io_data_0_read;
    reg  reg_spi_0_io_data_0_write;
    reg  reg_spi_0_io_data_0_writeEnable;
    reg  reg_spi_0_io_data_1_read;
    reg  reg_spi_0_io_data_1_write;
    reg  reg_spi_0_io_data_1_writeEnable;
    reg  reg_spi_0_io_data_2_read;
    reg  reg_spi_0_io_data_2_write;
    reg  reg_spi_0_io_data_2_writeEnable;
    reg  reg_spi_0_io_data_3_read;
    reg  reg_spi_0_io_data_3_write;
    reg  reg_spi_0_io_data_3_writeEnable;
    reg  reg_spi_0_io_sclk_write;
    reg  [0:0] reg_spi_0_io_ss;
    wire wire_spi_0_io_data_0_read;
    wire wire_spi_0_io_data_0_write;
    wire wire_spi_0_io_data_0_writeEnable;
    wire wire_spi_0_io_data_1_read;
    wire wire_spi_0_io_data_1_write;
    wire wire_spi_0_io_data_1_writeEnable;
    wire wire_spi_0_io_data_2_read;
    wire wire_spi_0_io_data_2_write;
    wire wire_spi_0_io_data_2_writeEnable;
    wire wire_spi_0_io_data_3_read;
    wire wire_spi_0_io_data_3_write;
    wire wire_spi_0_io_data_3_writeEnable;
    wire wire_spi_0_io_sclk_write;
    wire [0:0] wire_spi_0_io_ss;
    
    assign io_pllResetn                = io_asyncResetn;
    assign io_socReset                 = ~io_pllLocked;
    assign o_led[1:0]                  = system_gpio_0_io_write[1:0];
    assign system_gpio_0_io_read[0]    = pushsw;
    assign system_gpio_0_io_read[15:1] = 15'h7FFF;
    
    assign i2c_0_io_scl_writeEnable = ~system_i2c_0_io_scl_write;
    assign i2c_0_io_sda_writeEnable = ~system_i2c_0_io_sda_write;
    assign i2c_1_io_scl_writeEnable = ~system_i2c_1_io_scl_write;
    assign i2c_1_io_sda_writeEnable = ~system_i2c_1_io_sda_write;
    assign i2c_0_io_scl_write = 1'b0;
    assign i2c_0_io_sda_write = 1'b0;
    assign i2c_1_io_scl_write = 1'b0;
    assign i2c_1_io_sda_write = 1'b0;
    assign system_i2c_0_io_scl_read = i2c_1_io_scl_read;
    assign system_i2c_0_io_sda_read = i2c_1_io_sda_read;
    assign system_i2c_1_io_scl_read = i2c_1_io_scl_read;
    assign system_i2c_1_io_sda_read = i2c_1_io_sda_read;
    
    reg  io_systemClk;
    reg  io_systemClk2;
    reg  io_systemClk3;
    reg [9:0] cntdiv;
    
    (* syn_preserve = "true" *) reg tri_clk_1;
    (* syn_preserve = "true" *) reg tri_clk_2;
    (* syn_preserve = "true" *) reg tri_clk_3;
    
    always@(posedge CLK125M)
    begin
      if (~io_pllResetn)
        cntdiv <= 10'b0000011111;
      else
        cntdiv <= {cntdiv[8:0], cntdiv[9]};
    end
    
    always@(posedge CLK125M)
    begin
        io_systemClk <= cntdiv[0];
        io_systemClk2 <= cntdiv[7];
        io_systemClk3 <= cntdiv[3];
    end
    
    
    sap u_sap(
    .io_systemClk                       ( io_systemClk ),
    .io_systemClk2                      ( io_systemClk2 ),
    .io_systemClk3                      ( io_systemClk3 ),
    .jtagCtrl_enable                    ( jtagCtrl_enable ),
    .jtagCtrl_tdi                       ( jtagCtrl_tdi ),
    .jtagCtrl_capture                   ( jtagCtrl_capture ),
    .jtagCtrl_shift                     ( jtagCtrl_shift ),
    .jtagCtrl_update                    ( jtagCtrl_update ),
    .jtagCtrl_reset                     ( jtagCtrl_reset ),
    .jtagCtrl_tdo                       ( jtagCtrl_tdo ),
    .jtagCtrl_tck                       ( jtagCtrl_tck ),
    .system_spi_0_io_data_0_read        ( wire_spi_0_io_data_0_read ),
    .system_spi_0_io_data_0_write       ( wire_spi_0_io_data_0_write ),
    .system_spi_0_io_data_0_writeEnable ( wire_spi_0_io_data_0_writeEnable ),
    .system_spi_0_io_data_1_read        ( wire_spi_0_io_data_1_read ),
    .system_spi_0_io_data_1_write       ( wire_spi_0_io_data_1_write ),
    .system_spi_0_io_data_1_writeEnable ( wire_spi_0_io_data_1_writeEnable ),
    .system_spi_0_io_data_2_read        ( wire_spi_0_io_data_2_read ),
    .system_spi_0_io_data_2_write       ( wire_spi_0_io_data_2_write ),
    .system_spi_0_io_data_2_writeEnable ( wire_spi_0_io_data_2_writeEnable ),
    .system_spi_0_io_data_3_read        ( wire_spi_0_io_data_3_read ),
    .system_spi_0_io_data_3_write       ( wire_spi_0_io_data_3_write ),
    .system_spi_0_io_data_3_writeEnable ( wire_spi_0_io_data_3_writeEnable ),
    .system_spi_0_io_sclk_write         ( wire_spi_0_io_sclk_write ),
    .system_spi_0_io_ss                 ( wire_spi_0_io_ss ),
    .io_asyncReset                      ( io_socReset ),
    .io_systemReset                     ( io_systemReset ),
    .system_uart_0_io_txd               ( system_uart_0_io_txd ),
    .system_uart_0_io_rxd               ( system_uart_0_io_rxd ),
    .system_i2c_1_io_sda_read           ( system_i2c_1_io_sda_read ),
    .system_i2c_1_io_scl_write          ( system_i2c_1_io_scl_write ),
    .system_i2c_1_io_scl_read           ( system_i2c_1_io_scl_read ),
    .system_i2c_1_io_sda_write          ( system_i2c_1_io_sda_write ),
    .system_i2c_0_io_scl_read           ( system_i2c_0_io_scl_read ),
    .system_i2c_0_io_scl_write          ( system_i2c_0_io_scl_write ),
    .system_i2c_0_io_sda_read           ( system_i2c_0_io_sda_read ),
    .system_i2c_0_io_sda_write          ( system_i2c_0_io_sda_write ),
    .system_gpio_0_io_writeEnable       ( system_gpio_0_io_writeEnable ),
    .system_gpio_0_io_write             ( system_gpio_0_io_write ),
    .system_gpio_0_io_read              ( system_gpio_0_io_read )
    );
    
    
    
    always@(posedge io_systemClk)
    begin
      reg_spi_0_io_data_0_read        <= system_spi_0_io_data_0_read; 
      reg_spi_0_io_data_0_write       <=   wire_spi_0_io_data_0_write; 
      reg_spi_0_io_data_0_writeEnable <=   wire_spi_0_io_data_0_writeEnable;
      reg_spi_0_io_data_1_read        <= system_spi_0_io_data_1_read; 
      reg_spi_0_io_data_1_write       <=   wire_spi_0_io_data_1_write;
      reg_spi_0_io_data_1_writeEnable <=   wire_spi_0_io_data_1_writeEnable;
      reg_spi_0_io_data_2_read        <= system_spi_0_io_data_2_read;
      reg_spi_0_io_data_2_write       <=   wire_spi_0_io_data_2_write;
      reg_spi_0_io_data_2_writeEnable <=   wire_spi_0_io_data_2_writeEnable;
      reg_spi_0_io_data_3_read        <= system_spi_0_io_data_3_read;
      reg_spi_0_io_data_3_write       <=   wire_spi_0_io_data_3_write; 
      reg_spi_0_io_data_3_writeEnable <=   wire_spi_0_io_data_3_writeEnable;
      reg_spi_0_io_sclk_write         <=   wire_spi_0_io_sclk_write;
      reg_spi_0_io_ss                 <=   wire_spi_0_io_ss;
    end
    
    
    // Input
    assign wire_spi_0_io_data_0_read          = reg_spi_0_io_data_0_read;
    assign wire_spi_0_io_data_1_read          = reg_spi_0_io_data_1_read;
    assign wire_spi_0_io_data_2_read          = reg_spi_0_io_data_2_read;
    assign wire_spi_0_io_data_3_read          = reg_spi_0_io_data_3_read;
    
    // Output
    assign system_spi_0_io_data_0_write       = reg_spi_0_io_data_0_write;
    assign system_spi_0_io_data_0_writeEnable = reg_spi_0_io_data_0_writeEnable;
    assign system_spi_0_io_data_1_write       = reg_spi_0_io_data_1_write;      
    assign system_spi_0_io_data_1_writeEnable = reg_spi_0_io_data_1_writeEnable;
    assign system_spi_0_io_data_2_write       = reg_spi_0_io_data_2_write;      
    assign system_spi_0_io_data_2_writeEnable = reg_spi_0_io_data_2_writeEnable;
    assign system_spi_0_io_data_3_write       = reg_spi_0_io_data_3_write;      
    assign system_spi_0_io_data_3_writeEnable = reg_spi_0_io_data_3_writeEnable;
    assign system_spi_0_io_sclk_write         = reg_spi_0_io_sclk_write;        
    assign system_spi_0_io_ss                 = reg_spi_0_io_ss;        
    
    
    
    
    

endmodule