interface simple_if(input logic clk);
    logic [15:0] data;
    logic        data_ready;

    modport master (
        output data,
        output data_ready
    );

    modport slave (
        input data,
        input data_ready
    );
endinterface
