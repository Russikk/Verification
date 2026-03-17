interface simple_if(input logic clk); 
    logic rst;
    logic [15:0] data;
    logic        data_ready;

    modport master (
        output data, rst,
        output data_ready
    );

    modport slave (
        input data, rst,
        input data_ready
    );
endinterface
