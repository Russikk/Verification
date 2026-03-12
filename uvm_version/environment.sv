`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "agent.sv"
`include "scoreboard.sv"

class Environment extends uvm_env;
    `uvm_component_utils(Environment)
    
    Agent      agent;
    Scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        agent      = Agent::type_id::create("agent", this);
        scoreboard = Scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        agent.monitor.ap.connect(scoreboard.analysis_export);
    endfunction

endclass

`endif
