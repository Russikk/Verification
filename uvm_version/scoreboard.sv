`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.sv"

class Scoreboard extends uvm_scoreboard;
    `uvm_component_utils(Scoreboard)

    uvm_analysis_imp #(Transaction, Scoreboard) analysis_export;

    int passed = 0;
    int failed = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_export = new("analysis_export", this);
    endfunction

    virtual function void write(Transaction tr);
        bit [3:0] predicted_result;
        bit       predicted_err;
        
        predicted_err = 0;
        
        case (tr.opcode)
            3'd0: begin // ADD
                predicted_result = tr.a + tr.b;
                if (tr.a + tr.b > 15) predicted_err = 1'b1;
            end
            3'd1: begin // SUB
                predicted_result = tr.a - tr.b;
                if (tr.a < tr.b) predicted_err = 1'b1;
            end
            3'd2: begin // XOR
                predicted_result = tr.a ^ tr.b;
                if (predicted_result == 4'd0) predicted_err = 1'b1;
            end
            3'd3: begin // AND
                predicted_result = tr.a & tr.b;
                if (predicted_result == 4'b1111) predicted_err = 1'b1;
            end
            3'd4: begin // OR
                predicted_result = tr.a | tr.b;
                if (predicted_result == 4'd0) predicted_err = 1'b1;
            end
            default: begin
                predicted_result = 4'd0;
                predicted_err = 1'b1;
            end
        endcase

        // Порівняння
        if ((tr.result === predicted_result) && (tr.error === predicted_err)) begin
            passed++;
            `uvm_info("SB_PASS", $sformatf("Match! Op:%0d A:%0d B:%0d Res:%0d", tr.opcode, tr.a, tr.b, tr.result), UVM_HIGH)
        end else begin
            failed++;
            `uvm_error("SB_MISMATCH", 
                $sformatf("Mismatch! Op:%0d A:%0d B:%0d | Act:{Res:%0d, Err:%b} Exp:{Res:%0d, Err:%b}",
                tr.opcode, tr.a, tr.b, tr.result, tr.error, predicted_result, predicted_err))
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SB_FINAL", $sformatf("\n\n--- FINAL SUMMARY ---\n PASSED: %0d\n FAILED: %0d\n----------------------\n", passed, failed), UVM_LOW)
    endfunction

endclass

`endif
