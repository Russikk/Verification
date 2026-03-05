`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "transaction.sv"
`include "config_obj.sv"
`include "cbs.sv"
`include "utils.sv"

class Scoreboard extends MonitorCallback;
    ConfigObj cfg;
    int passed = 0;
    int failed = 0;
    bit configured = 0;

    function void configure(ConfigObj cfg_obj);
        this.cfg = cfg_obj;
        configured = 1;
    endfunction

    virtual function void write(Transaction tr);
        bit [3:0] predicted_result;
        bit       predicted_err;
        
        if (!configured) return;

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

        if ((tr.result === predicted_result) && (tr.error === predicted_err)) begin
            passed++;
        end else begin
            failed++;
            $error("[SCOREBOARD] Mismatch! Op:%0d A:%0d B:%0d | Act:{Res:%0d, Err:%b} Exp:{Res:%0d, Err:%b}",
                    tr.opcode, tr.a, tr.b, tr.result, tr.error, predicted_result, predicted_err);
        end
    endfunction

    function void report(string test_name = "General Analysis");
        print_test_summary(passed, failed, test_name);
    endfunction

endclass
`endif
