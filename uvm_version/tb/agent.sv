`ifndef AGENT_SV
`define AGENT_SV

class Agent extends uvm_agent;
    `uvm_component_utils(Agent)

    Driver    driver;
    Monitor   monitor;
    Sequencer sequencer;
    
    string    vif_tag; 

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (!uvm_config_db#(string)::get(this, "", "vif_tag", vif_tag)) begin
            `uvm_fatal("AGT", $sformatf("No vif_tag provided for agent: %s", get_full_name()))
        end

        monitor = Monitor::type_id::create("monitor", this);
        uvm_config_db#(string)::set(this, "monitor", "vif_tag", vif_tag);

        if (get_is_active() == UVM_ACTIVE) begin
            sequencer = Sequencer::type_id::create("sequencer", this);
            driver    = Driver::type_id::create("driver", this);
            
            uvm_config_db#(string)::set(this, "driver", "vif_tag", vif_tag);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass

`endif
