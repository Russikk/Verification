module top;
    import uvm_pkg::*;
    import testbench_pkg::*;
    `include "uvm_macros.svh"
    
    logic clk;
    logic rst;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #25 rst = 0;
    end

    simple_if intf_in[3](clk);
    simple_if intf_out[3](clk);
    config_if cfg_intf();

    generate
        for (genvar j = 0; j < 3; j++) begin : rst_assign
            assign intf_in[j].rst  = rst;
            assign intf_out[j].rst = rst;
        end
    endgenerate

    dut full_system (
        .clk             (clk),
        .rst             (rst),
        .cfg             (cfg_intf),
        
        .simple_if_in_0  (intf_in[0]),
        .simple_if_in_1  (intf_in[1]),
        .simple_if_in_2  (intf_in[2]),
        
        .simple_if_out_0 (intf_out[0]),
        .simple_if_out_1 (intf_out[1]),
        .simple_if_out_2 (intf_out[2])
    );

    initial begin
        uvm_config_db#(virtual simple_if)::set(null, "*", "vif_in_0", intf_in[0]);
        uvm_config_db#(virtual simple_if)::set(null, "*", "vif_in_1", intf_in[1]);
        uvm_config_db#(virtual simple_if)::set(null, "*", "vif_in_2", intf_in[2]);

        uvm_config_db#(virtual simple_if)::set(null, "*", "vif_out_0", intf_out[0]);
        uvm_config_db#(virtual simple_if)::set(null, "*", "vif_out_1", intf_out[1]);
        uvm_config_db#(virtual simple_if)::set(null, "*", "vif_out_2", intf_out[2]);

        uvm_config_db#(virtual config_if)::set(null, "*", "cfg_vif", cfg_intf);
        
        run_test("base_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end

endmodule
