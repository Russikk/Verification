`ifndef TEST_LIB_SV
`define TEST_LIB_SV

`include "transaction.sv"

//ADD, SUB
class Transaction_Arithmetic extends Transaction;// Успадковує всі поля від базової Transaction
    
    constraint valid_op {
        opcode inside {0, 1}; // 0=ADD, 1=SUB
    }

    virtual function Transaction copy();
        Transaction_Arithmetic tr = new();// Створюємо екземпляр саме ЦЬОГО дочірнього класу (Arithmetic)
        tr.opcode = this.opcode;
        tr.a = this.a;
        tr.b = this.b;
        tr.result = this.result;
        tr.error = this.error;
        return tr;
    endfunction

endclass

// XOR, AND, OR
class Transaction_Logic extends Transaction;
    
    constraint valid_op {
        opcode inside {2, 3, 4}; // Logic ops
    }

    virtual function Transaction copy();
        Transaction_Logic tr = new();
        tr.opcode = this.opcode;
        tr.a = this.a;
        tr.b = this.b;
        tr.result = this.result;
        tr.error = this.error;
        return tr;
    endfunction

endclass

// RESERVED OPCODES (Negative Testing)
class Transaction_Reserved extends Transaction;
    // Перевизначаємо базове обмеження: генеруємо ТІЛЬКИ зарезервовані коди
    constraint valid_op { 
        opcode inside {[5:7]}; 
    }
    virtual function Transaction copy();
        Transaction_Reserved tr = new();
        tr.opcode = this.opcode;
        tr.a = this.a;
        tr.b = this.b;
        tr.result = this.result;
        tr.error = this.error;
        return tr;
    endfunction
endclass

`endif
