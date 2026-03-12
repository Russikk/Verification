module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `include "base_test.sv"

    bit clk;
    bit rst; 

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20 rst = 0;
    end


    simple_if intf(clk);
    config_if cfg_intf();

    computation_module dut (
        .clk      (clk),
        .rst      (rst),
        .bus_in   (intf),
        .bus_out  (intf)
    );

 
    initial begin
        uvm_config_db#(virtual simple_if)::set(null, "*", "vif", intf);
        uvm_config_db#(virtual config_if)::set(null, "*", "cfg_vif", cfg_intf);
        
        run_test("base_test");
    end


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end

endmodule
