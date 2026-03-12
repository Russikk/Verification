class Driver extends uvm_driver #(Transaction);
    `uvm_component_utils(Driver)
    virtual simple_if vif;
    virtual config_if cfg_vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "No simple_if")
            
        if(!uvm_config_db#(virtual config_if)::get(this, "", "cfg_vif", cfg_vif))
            `uvm_fatal("DRV", "No config_if")
    endfunction

    virtual task run_phase(uvm_phase phase);
    wait(vif.rst === 0);

    @(posedge vif.clk); 

    forever begin
        seq_item_port.get_next_item(req); 
        
        cfg_vif.in0_to_comp = 2'b01;

        @(posedge vif.clk);

        vif.data <= {req.opcode, req.a, req.b, 5'b0};
        vif.data_ready <= 1'b1;

        @(posedge vif.clk);
        
        vif.data_ready <= 1'b0;
        vif.data <= '0;

        seq_item_port.item_done(); 
    end
endtask
endclass
