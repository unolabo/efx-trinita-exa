import shutil

def ConvSap2Tri():
    shutil.copyfile("sap.v", "sap(origin).v")
    f = open ("sap(origin).v", "r", encoding="utf-8")
    f_new = open("sap.v", "w", encoding="utf-8")
    
    vex_replace = """\
);
`else
  vr_wrapper system_cores_0_logic_cpu (
    // System Siangl
    .systemCd_logic_outputReset       (systemCd_logic_outputReset                                 ), //i
    .debugCd_logic_outputReset        (debugCd_logic_outputReset                                  ), //i
    .debug_resetOut                   (system_cores_0_logic_cpu_debug_resetOut                    ), //o
    .io_systemClk                     (io_systemClk                                               ), //i
    .io_systemClk2                    (io_systemClk2                                              ), //i

    // Data Bus
    .dBus_cmd_valid                   (system_cores_0_logic_cpu_dBus_cmd_valid                    ), //o
    .dBus_cmd_ready                   (system_cores_0_dBus_cmd_ready                              ), //i
    .dBus_cmd_payload_wr              (system_cores_0_logic_cpu_dBus_cmd_payload_wr               ), //o
    .dBus_cmd_payload_address         (system_cores_0_logic_cpu_dBus_cmd_payload_address[31:0]    ), //o
    .dBus_cmd_payload_data            (system_cores_0_logic_cpu_dBus_cmd_payload_data[31:0]       ), //o
    .dBus_cmd_payload_size            (system_cores_0_logic_cpu_dBus_cmd_payload_size[1:0]        ), //o
    .dBus_rsp_ready                   (system_cores_0_logic_cpu_dBus_rsp_ready                    ), //i
    .dBus_rsp_error                   (system_cores_0_logic_cpu_dBus_rsp_error                    ), //i
    .dBus_rsp_data                    (system_cores_0_dBus_rsp_payload_fragment_data[31:0]        ), //i

    // Interrupt
    .timerInterrupt                   (_zz_timerInterrupt                                         ), //i
    .externalInterrupt                (system_cores_0_externalInterrupt_plic_target_iep_regNext   ), //i
    .softwareInterrupt                (_zz_softwareInterrupt                                      ), //i

    // Debug Interface
    .debug_bus_cmd_valid              (system_cores_0_debugBmb_cmd_valid                          ), //i
    .debug_bus_cmd_ready              (system_cores_0_logic_cpu_debug_bus_cmd_ready               ), //o
    .debug_bus_cmd_payload_wr         (system_cores_0_logic_cpu_debug_bus_cmd_payload_wr          ), //i
    .debug_bus_cmd_payload_address    (system_cores_0_debugBmb_cmd_payload_fragment_address[7:0]  ), //i
    .debug_bus_cmd_payload_data       (system_cores_0_debugBmb_cmd_payload_fragment_data[31:0]    ), //i
    .debug_bus_rsp_data               (system_cores_0_logic_cpu_debug_bus_rsp_data[31:0]          ), //o

    // RAM Interface
    .io_bus_cmd_valid                       (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid                           ), //i
    .io_bus_cmd_ready                       (system_ramA_logic_io_bus_cmd_ready                                                          ), //o
    .io_bus_cmd_payload_last                (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last                    ), //i
    .io_bus_cmd_payload_fragment_source     (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_source         ), //i
    .io_bus_cmd_payload_fragment_opcode     (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode         ), //i
    .io_bus_cmd_payload_fragment_address    (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address[14:0]  ), //i
    .io_bus_cmd_payload_fragment_length     (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length[1:0]    ), //i
    .io_bus_cmd_payload_fragment_data       (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data[31:0]     ), //i
    .io_bus_cmd_payload_fragment_mask       (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_mask[3:0]      ), //i
    .io_bus_cmd_payload_fragment_context    (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context        ), //i
    .io_bus_rsp_valid                       (system_ramA_logic_io_bus_rsp_valid                                                          ), //o
    .io_bus_rsp_ready                       (system_ramA_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready                           ), //i
    .io_bus_rsp_payload_last                (system_ramA_logic_io_bus_rsp_payload_last                                                   ), //o
    .io_bus_rsp_payload_fragment_source     (system_ramA_logic_io_bus_rsp_payload_fragment_source                                        ), //o
    .io_bus_rsp_payload_fragment_opcode     (system_ramA_logic_io_bus_rsp_payload_fragment_opcode                                        ), //o
    .io_bus_rsp_payload_fragment_data       (system_ramA_logic_io_bus_rsp_payload_fragment_data[31:0]                                    ), //o
    .io_bus_rsp_payload_fragment_context    (system_ramA_logic_io_bus_rsp_payload_fragment_context                                       )  //o
  );
  assign system_cores_0_logic_cpu_iBus_cmd_valid      = 1'b0;
  assign system_cores_0_logic_cpu_iBus_cmd_payload_pc = 32'd0;
`endif

"""
    
    state = 0
    for line in f:
        newline = line
        
        if ("`define IP_UUID " in line):
            newline = line.replace("`define IP_UUID ", "`define TRINITA\n`define IP_UUID ")
            state = 1
        elif (state==1 and "input io_systemClk," in line):
            newline = line.replace("input io_systemClk,", "input io_systemClk,\ninput io_systemClk2,")
            state = 2
        elif (state==2 and ".io_systemClk ( io_systemClk )," in line) :
            newline = line.replace(".io_systemClk ( io_systemClk ),", ".io_systemClk ( io_systemClk ),\n.io_systemClk2 ( io_systemClk2 ),")
            state = 3
        elif (state==3 and "module EfxSapphireSoc_" in line):
            state = 4
        elif (state==4 and "io_systemClk" in line):
            newline = line.replace("io_systemClk,", "io_systemClk,\n  input               io_systemClk2,")
            state = 5
        elif (state==5 and "VexRiscv_" in line):
            newline = "`ifndef TRINITA\n" + line
            state = 6
        elif (state==6 and ");" in line):
            newline = line.replace(");", vex_replace)
            state = 7
        elif (state==7 and "BmbOnChipRam_" in line):
            newline = "`ifndef TRINITA\n" + line
            state = 8
        elif (state==8 and ");" in line):
            newline = line + "`endif\n"
            state = 9
        elif (state==9 and "module VexRiscv_" in line):
            newline = "`ifndef TRINITA\n" + line
            state = 10
        elif (state == 10 and "endmodule" in line):
            newline = line + "`endif\n"
            state = 11
        
        f_new.write(newline)
    

def main():
    ConvSap2Tri()
    

if __name__ == "__main__":
    main()
