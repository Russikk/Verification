interface config_if;
    logic [1:0] in0_to_comp; 
    logic [1:0] in1_to_comp; 
    logic [1:0] in2_to_comp; 

    modport disp (
        input in0_to_comp,
        input in1_to_comp,
        input in2_to_comp
    );

    modport driver (
        output in0_to_comp,
        output in1_to_comp,
        output in2_to_comp
    );
endinterface
