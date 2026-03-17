`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV
class Environment extends uvm_env;
    `uvm_component_utils(Environment)

    Agent in_ag[3];
    Agent out_ag[3];
    Scoreboard sb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb = Scoreboard::type_id::create("sb", this);
        
        for(int i=0; i<3; i++) begin
            in_ag[i]  = Agent::type_id::create($sformatf("in_ag_%0d", i), this);
            out_ag[i] = Agent::type_id::create($sformatf("out_ag_%0d", i), this);
            

            uvm_config_db#(string)::set(this, $sformatf("in_ag_%0d*", i), "vif_tag", $sformatf("vif_in_%0d", i));
            uvm_config_db#(string)::set(this, $sformatf("out_ag_%0d*", i), "vif_tag", $sformatf("vif_out_%0d", i));
            
            uvm_config_db#(int)::set(this, $sformatf("out_ag_%0d", i), "is_active", UVM_PASSIVE);
        end
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        in_ag[0].monitor.ap.connect(sb.in0_export);
        in_ag[1].monitor.ap.connect(sb.in1_export);
        in_ag[2].monitor.ap.connect(sb.in2_export);
        
        out_ag[0].monitor.ap.connect(sb.out0_export);
        out_ag[1].monitor.ap.connect(sb.out1_export);
        out_ag[2].monitor.ap.connect(sb.out2_export);
    endfunction
endclass

`endif
