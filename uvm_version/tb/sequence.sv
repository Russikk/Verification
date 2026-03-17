`ifndef SEQUENCE_SV
`define SEQUENCE_SV

class base_sequence extends uvm_sequence #(Transaction);
    `uvm_object_utils(base_sequence)

    int num_transactions = 1000;

    function new(string name = "base_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("SEQ", $sformatf("Starting generation of %0d transactions...", num_transactions), UVM_LOW)
        
        repeat(num_transactions) begin
            req = Transaction::type_id::create("req");
            
            start_item(req);
            
            if (!req.randomize()) begin
                `uvm_fatal("SEQ", "Randomization failed! Check constraints in Transaction class.")
            end
            
            finish_item(req);
        end
        
        `uvm_info("SEQ", "Sequence finished successfully.", UVM_LOW)
    endtask
endclass

`endif
