`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`uvm_analysis_imp_decl(_in0)
`uvm_analysis_imp_decl(_in1)
`uvm_analysis_imp_decl(_in2)
`uvm_analysis_imp_decl(_out0)
`uvm_analysis_imp_decl(_out1)
`uvm_analysis_imp_decl(_out2)

class Scoreboard extends uvm_scoreboard;
    `uvm_component_utils(Scoreboard)

    uvm_analysis_imp_in0 #(Transaction, Scoreboard) in0_export;
    uvm_analysis_imp_in1 #(Transaction, Scoreboard) in1_export;
    uvm_analysis_imp_in2 #(Transaction, Scoreboard) in2_export;
    
    uvm_analysis_imp_out0 #(Transaction, Scoreboard) out0_export;
    uvm_analysis_imp_out1 #(Transaction, Scoreboard) out1_export;
    uvm_analysis_imp_out2 #(Transaction, Scoreboard) out2_export;


    uvm_tlm_analysis_fifo #(Transaction) fifo_in[3];
    uvm_tlm_analysis_fifo #(Transaction) fifo_out[3];

    int passed = 0;
    int failed = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        in0_export = new("in0_export", this);
        in1_export = new("in1_export", this);
        in2_export = new("in2_export", this);
        
        out0_export = new("out0_export", this);
        out1_export = new("out1_export", this);
        out2_export = new("out2_export", this);

        for(int i=0; i<3; i++) begin
            fifo_in[i]  = new($sformatf("fifo_in_%0d", i), this);
            fifo_out[i] = new($sformatf("fifo_out_%0d", i), this);
        end
    endfunction

    function void write_in0(Transaction tr); fifo_in[0].write(tr); endfunction
    function void write_in1(Transaction tr); fifo_in[1].write(tr); endfunction
    function void write_in2(Transaction tr); fifo_in[2].write(tr); endfunction
    
    function void write_out0(Transaction tr); fifo_out[0].write(tr); endfunction
    function void write_out1(Transaction tr); fifo_out[1].write(tr); endfunction
    function void write_out2(Transaction tr); fifo_out[2].write(tr); endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            process_channel(0);
            process_channel(1);
            process_channel(2);
        join_none
    endtask

    virtual task process_channel(int idx);
        Transaction tr_in, tr_out;
        forever begin
            fifo_in[idx].get(tr_in);
            fifo_out[idx].get(tr_out);
            compare(tr_in, tr_out, idx);
        end
    endtask

    function void compare(Transaction tr_in, Transaction tr_out, int ch);
        bit [3:0] exp_res;
        bit       exp_err;
        
        exp_err = 0;
        case (tr_in.opcode)
            3'd0: begin // ADD
                {exp_err, exp_res} = tr_in.a + tr_in.b;
            end
            3'd1: begin // SUB
                exp_res = tr_in.a - tr_in.b;
                exp_err = (tr_in.a < tr_in.b);
            end
            3'd2: begin // XOR
                exp_res = tr_in.a ^ tr_in.b;
                exp_err = (exp_res == 0);
            end
            3'd3: begin // AND
                exp_res = tr_in.a & tr_in.b;
                exp_err = (exp_res == 4'b1111);
            end
            3'd4: begin // OR
                exp_res = tr_in.a | tr_in.b;
                exp_err = (exp_res == 0);
            end
            default: begin
                exp_res = 0;
                exp_err = 1;
            end
        endcase

        if ((tr_out.result === exp_res) && (tr_out.error === exp_err)) begin
            passed++;
            `uvm_info("SB_MATCH", $sformatf("CH %0d: Match! Op:%0d A:%0d B:%0d Res:%0d Err:%b", 
                      ch, tr_in.opcode, tr_in.a, tr_in.b, tr_out.result, tr_out.error), UVM_MEDIUM)
        end else begin
            failed++;
            `uvm_error("SB_MISMATCH", $sformatf("CH %0d: Mismatch! Op:%0d A:%0d B:%0d | Act:{R:%0d, E:%b} Exp:{R:%0d, E:%b}", 
                       ch, tr_in.opcode, tr_in.a, tr_in.b, tr_out.result, tr_out.error, exp_res, exp_err))
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("\n========================================");
        $display("      SCOREBOARD FINAL REPORT");
        $display("      PASSED: %0d", passed);
        $display("      FAILED: %0d", failed);
        $display("========================================\n");
    endfunction
endclass

`endif
