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
        if (!configured) return;

        case (tr.opcode)
            3'd0: predicted_result = tr.a + tr.b; 
            3'd1: predicted_result = tr.a - tr.b; 
            3'd2: predicted_result = tr.a ^ tr.b; 
            3'd3: predicted_result = tr.a & tr.b; 
            3'd4: predicted_result = tr.a | tr.b; 
            default: predicted_result = 0;
        endcase

        if (tr.result == predicted_result) passed++;
        else failed++;
    endfunction

    function void report(string test_name = "General Analysis");
        // Викликаємо функцію з utils.sv і передаємо їй ім'я
        print_test_summary(passed, failed, test_name);
    endfunction

endclass
`endif
