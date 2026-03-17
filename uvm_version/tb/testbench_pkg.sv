package testbench_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "transaction.sv"

    `include "driver.sv"
    `include "monitor.sv"

    typedef uvm_sequencer #(Transaction) Sequencer;

    `include "agent.sv"
    `include "scoreboard.sv"
    `include "environment.sv"
    `include "sequence.sv"
    `include "base_test.sv"
endpackage
