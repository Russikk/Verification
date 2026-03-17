module dut (
    input logic clk,
    input logic rst,

    config_if.disp    cfg,

    simple_if.slave   simple_if_in_0,
    simple_if.slave   simple_if_in_1,
    simple_if.slave   simple_if_in_2,

    simple_if.master  simple_if_out_0,
    simple_if.master  simple_if_out_1,
    simple_if.master  simple_if_out_2
);


    //створюємо екземпляри інтерфейсу і передаємо їм clk
    simple_if disp_to_comp0(clk);
    simple_if disp_to_comp1(clk);
    simple_if disp_to_comp2(clk);

    dispatcher u_dispatcher (
        .cfg          (cfg),
        
        .in0          (simple_if_in_0),
        .in1          (simple_if_in_1),
        .in2          (simple_if_in_2),
        
        .out_to_comp0 (disp_to_comp0),
        .out_to_comp1 (disp_to_comp1),
        .out_to_comp2 (disp_to_comp2)
    );


    computation_module u_comp0 (
        .clk     (clk),
        .rst     (rst),
        .bus_in  (disp_to_comp0),  
        .bus_out (simple_if_out_0) 
    );

    computation_module u_comp1 (
        .clk     (clk),
        .rst     (rst),
        .bus_in  (disp_to_comp1),   
        .bus_out (simple_if_out_1)
    );

    computation_module u_comp2 (
        .clk     (clk),
        .rst     (rst),
        .bus_in  (disp_to_comp2),   
        .bus_out (simple_if_out_2)
    );

endmodule
