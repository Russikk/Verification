`ifndef BASE_TEST_SV
`define BASE_TEST_SV
import uvm_pkg::*;
`include "uvm_macros.svh"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    Environment env;
    virtual config_if cfg_vif;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = Environment::type_id::create("env", this);
       if(!uvm_config_db#(virtual config_if)::get(this, "", "cfg_vif", cfg_vif))
            `uvm_fatal("TEST", "No config_if interface found in database!")
    endfunction

	

    virtual task run_phase(uvm_phase phase);
 
        base_sequence seq[3];
        
        phase.raise_objection(this);

	`uvm_info("TEST", "Configuring Dispatcher routing...", UVM_LOW)
        cfg_vif.in0_to_comp = 2'd0; // Вхід 0 йде на Computation Module 0
        cfg_vif.in1_to_comp = 2'd1; // Вхід 1 йде на Computation Module 1
        cfg_vif.in2_to_comp = 2'd2; // Вхід 2 йде на Computation Module 2

        `uvm_info("TEST", "Initializing sequences...", UVM_LOW)
        for(int i=0; i<3; i++) begin
            seq[i] = base_sequence::type_id::create($sformatf("seq_%0d", i));
            seq[i].num_transactions = 1000; 
        end

        `uvm_info("TEST", "Starting parallel sequences on 3 input ports", UVM_LOW)
        
        fork
            seq[0].start(env.in_ag[0].sequencer);
            seq[1].start(env.in_ag[1].sequencer);
            seq[2].start(env.in_ag[2].sequencer);
        join

        `uvm_info("TEST", "Sequences finished. Waiting for out-of-flight data...", UVM_LOW)
        #100ns;

        phase.drop_objection(this);
        `uvm_info("TEST", "All objections dropped. Test finished.", UVM_LOW)
    endtask

endclass

`endif
