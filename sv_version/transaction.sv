`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class Transaction;
    rand bit [2:0] opcode;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [3:0] result;
    bit error;

    constraint valid_op { opcode inside {[0:4]}; }

    function void display(string name);
        //$display("[%s] Op=%0d, A=%0d, B=%0d --> Res=%0d, Err=%0d", 
                 //name, opcode, a, b, result, error);
    endfunction

    virtual function Transaction copy();
        Transaction tr_copy = new();
        tr_copy.opcode = this.opcode;
        tr_copy.a = this.a;
        tr_copy.b = this.b;
        tr_copy.result = this.result;
        tr_copy.error = this.error;
        return tr_copy;
    endfunction

endclass

`endif
