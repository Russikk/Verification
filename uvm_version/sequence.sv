`ifndef SEQUENCE_SV
`define SEQUENCE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

// Сценарій — це об'єкт, який створює транзакції
class base_sequence extends uvm_sequence #(Transaction);
    `uvm_object_utils(base_sequence)

    function new(string name = "base_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("SEQ", "Starting generation of 1000 transactions...", UVM_LOW)
        
        repeat(1000) begin
            // Створюємо порожній об'єкт транзакції
            req = Transaction::type_id::create("req");
            
            // Чекаємо, поки Драйвер буде готовий
            start_item(req);
            
            // Рандомізуємо
            if (!req.randomize()) begin
                `uvm_fatal("SEQ", "Error")
            end
            
            // Віддаємо Драйверу
            finish_item(req);
        end
        
        `uvm_info("SEQ", "Finish", UVM_LOW)
    endtask
endclass

`endif
