`ifndef MONITOR_SV
`define MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.sv"

class Monitor extends uvm_monitor;
    `uvm_component_utils(Monitor)

    virtual simple_if vif;

    uvm_analysis_port #(Transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Створюємо порт
        ap = new("ap", this);
        // Дістаємо інтерфейс з бази
        if(!uvm_config_db#(virtual simple_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Could not get vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.data_ready) begin
                Transaction tr = Transaction::type_id::create("tr");
                
                // Розпаковка сигналів (твоя логіка без змін)
                tr.opcode = vif.data[15:13];
                tr.a      = vif.data[12:9];
                tr.b      = vif.data[8:5];
                tr.error  = vif.data[4];
                tr.result = vif.data[3:0];

                ap.write(tr);
                
                `uvm_info("MON", $sformatf("Captured: %s", tr.convert2string()), UVM_HIGH)
            end
        end
    endtask

endclass

`endif
