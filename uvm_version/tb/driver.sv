class Driver extends uvm_driver #(Transaction);
    `uvm_component_utils(Driver)
    
    virtual simple_if vif;
    virtual config_if cfg_vif;
    string vif_tag;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (!uvm_config_db#(string)::get(this, "", "vif_tag", vif_tag))
            `uvm_fatal("DRV", "vif_tag not found!")

        if(!uvm_config_db#(virtual simple_if)::get(this, "", vif_tag, vif))
            `uvm_fatal("DRV", $sformatf("Could not find interface: %s", vif_tag))
            
        if(!uvm_config_db#(virtual config_if)::get(this, "", "cfg_vif", cfg_vif))
            `uvm_fatal("DRV", "No config_if interface found!")
    endfunction

    virtual task run_phase(uvm_phase phase);

        vif.data_ready <= 1'b0;
        vif.data       <= '0;
        

        wait(vif.rst === 0);
        repeat(2) @(posedge vif.clk);

        forever begin
            seq_item_port.get_next_item(req);
            
            @(posedge vif.clk);
            vif.data_ready <= 1'b1;
            vif.data       <= {req.opcode, req.a, req.b, 5'b0};
            
            @(posedge vif.clk);
            vif.data_ready <= 1'b0;
            vif.data       <= '0;

            seq_item_port.item_done();
        end
    endtask
endclass
