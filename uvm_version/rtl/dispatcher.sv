module dispatcher (

    config_if.disp     cfg,

    simple_if.slave    in0,
    simple_if.slave    in1,
    simple_if.slave    in2,

    simple_if.master   out_to_comp0,
    simple_if.master   out_to_comp1,
    simple_if.master   out_to_comp2
);

    always_comb begin

        out_to_comp0.data       = '0;
        out_to_comp0.data_ready = 1'b0;

        if (cfg.in0_to_comp == 2'd0) begin

            out_to_comp0.data       = in0.data;
            out_to_comp0.data_ready = in0.data_ready;
        end 
        else if (cfg.in1_to_comp == 2'd0) begin
            out_to_comp0.data       = in1.data;
            out_to_comp0.data_ready = in1.data_ready;
        end 
        else if (cfg.in2_to_comp == 2'd0) begin
            out_to_comp0.data       = in2.data;
            out_to_comp0.data_ready = in2.data_ready;
        end

        out_to_comp1.data       = '0;
        out_to_comp1.data_ready = 1'b0;

        if (cfg.in0_to_comp == 2'd1) begin
            out_to_comp1.data       = in0.data;
            out_to_comp1.data_ready = in0.data_ready;
        end 
        else if (cfg.in1_to_comp == 2'd1) begin
            out_to_comp1.data       = in1.data;
            out_to_comp1.data_ready = in1.data_ready;
        end 
        else if (cfg.in2_to_comp == 2'd1) begin
            out_to_comp1.data       = in2.data;
            out_to_comp1.data_ready = in2.data_ready;
        end
        out_to_comp2.data       = '0;
        out_to_comp2.data_ready = 1'b0;

        if (cfg.in0_to_comp == 2'd2) begin
            out_to_comp2.data       = in0.data;
            out_to_comp2.data_ready = in0.data_ready;
        end 
        else if (cfg.in1_to_comp == 2'd2) begin
            out_to_comp2.data       = in1.data;
            out_to_comp2.data_ready = in1.data_ready;
        end 
        else if (cfg.in2_to_comp == 2'd2) begin
            out_to_comp2.data       = in2.data;
            out_to_comp2.data_ready = in2.data_ready;
        end
    end

endmodule
