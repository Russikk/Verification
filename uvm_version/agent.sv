`ifndef AGENT_SV
`define AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"
`include "driver.sv"
`include "monitor.sv"

typedef uvm_sequencer #(Transaction) Sequencer;

class Agent extends uvm_agent;
    `uvm_component_utils(Agent)

    Driver    driver;
    Monitor   monitor;
    Sequencer sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        monitor = Monitor::type_id::create("monitor", this);

        // В UVM агент ACTIVE (з драйвером) або PASSIVE (тільки монітор)
        if (get_is_active() == UVM_ACTIVE) begin
            driver    = Driver::type_id::create("driver", this);
            sequencer = Sequencer::type_id::create("sequencer", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass

`endif
