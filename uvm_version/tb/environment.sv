`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class Environment extends uvm_env;
    `uvm_component_utils(Environment)

    Agent in_ag[3];
    Agent out_ag[3];
    Scoreboard sb;
    
    // Масив колекторів функціонального покриття
    coverage_collector cov_coll[3];

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        sb = Scoreboard::type_id::create("sb", this);
        
        for(int i=0; i<3; i++) begin
            // Створення агентів
            in_ag[i]  = Agent::type_id::create($sformatf("in_ag_%0d", i), this);
            out_ag[i] = Agent::type_id::create($sformatf("out_ag_%0d", i), this);
            
            // Створення колекторів покриття
            cov_coll[i] = coverage_collector::type_id::create($sformatf("cov_coll_%0d", i), this);
            cov_coll[i].channel_id = i; // Передаємо ID каналу для звітів

            // Конфігурація віртуальних інтерфейсів
            uvm_config_db#(string)::set(this, $sformatf("in_ag_%0d*", i), "vif_tag", $sformatf("vif_in_%0d", i));
            uvm_config_db#(string)::set(this, $sformatf("out_ag_%0d*", i), "vif_tag", $sformatf("vif_out_%0d", i));
            
            // Налаштування вихідних агентів як пасивних (тільки моніторинг)
            uvm_config_db#(int)::set(this, $sformatf("out_ag_%0d", i), "is_active", UVM_PASSIVE);
        end
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // З'єднання вхідних моніторів зі Scoreboard
        in_ag[0].monitor.ap.connect(sb.in0_export);
        in_ag[1].monitor.ap.connect(sb.in1_export);
        in_ag[2].monitor.ap.connect(sb.in2_export);
        
        // З'єднання вихідних моніторів зі Scoreboard
        out_ag[0].monitor.ap.connect(sb.out0_export);
        out_ag[1].monitor.ap.connect(sb.out1_export);
        out_ag[2].monitor.ap.connect(sb.out2_export);

        // З'єднання вхідних моніторів з колекторами покриття
        for(int i=0; i<3; i++) begin
            in_ag[i].monitor.ap.connect(cov_coll[i].analysis_export);
        end
    endfunction
endclass

`endif
