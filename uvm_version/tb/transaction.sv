`ifndef TRANSACTION_SV
`define TRANSACTION_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class Transaction extends uvm_sequence_item;

    rand bit [2:0] opcode;
    rand bit [3:0] a;
    rand bit [3:0] b;
    bit [3:0] result;
    bit       error;

    `uvm_object_utils_begin(Transaction)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(a,      UVM_ALL_ON)
        `uvm_field_int(b,      UVM_ALL_ON)
        `uvm_field_int(result, UVM_ALL_ON)
        `uvm_field_int(error,  UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "Transaction");
        super.new(name);
    endfunction

    constraint c_op { opcode inside {[0:4]}; }

endclass

`endif
