`ifndef BASE_TEST_SV
`define BASE_TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "environment.sv"
`include "sequence.sv"

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    Environment env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = Environment::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);

        base_sequence seq = base_sequence::type_id::create("seq");

        phase.raise_objection(this);

        `uvm_info("TEST", "Start...", UVM_LOW)
        
        seq.start(env.agent.sequencer);

        phase.drop_objection(this);
        
        `uvm_info("TEST", "Finish", UVM_LOW)
    endtask

endclass

`endif
