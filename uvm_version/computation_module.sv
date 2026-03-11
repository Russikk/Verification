module computation_module (
    input  logic            clk,
    input  logic            rst,
    
    simple_if.slave         bus_in,
    simple_if.master        bus_out
);

    //
    // РОЗПАКОВКА ВХІДНИХ ДАНИХ
    logic [2:0] opcode_i;
    logic [3:0] a_i;
    logic [3:0] b_i;
    logic       start_i;

    assign opcode_i = bus_in.data[15:13];
    assign a_i      = bus_in.data[12:9];
    assign b_i      = bus_in.data[8:5];
    assign start_i  = bus_in.data_ready;

    logic [4:0] sum_full;   // Для перевірки переповнення ADD
    
    // Тимчасові змінні для збереження результату перед відправкою
    logic [3:0] tmp_result;
    logic       tmp_err;

    always_ff @(posedge clk) begin
        if (rst) begin
            bus_out.data       <= '0;
            bus_out.data_ready <= 0;
        end else begin
            bus_out.data_ready <= 0;

            if (start_i) begin

                tmp_err = 0;
                tmp_result = 0;

                case (opcode_i)
                    3'd0: begin // ADD
                        sum_full = a_i + b_i + 1; // ПОМИЛКА
                        tmp_result = sum_full[3:0];
                        if (sum_full[4]) tmp_err = 1'b1;
                    end

                    3'd1: begin // SUB
                        tmp_result = a_i - b_i;
                        if (a_i < b_i) tmp_err = 1'b1;
                    end

                    3'd2: begin // XOR
                        tmp_result = a_i ^ b_i;
                        if ((a_i ^ b_i) == 4'd0) tmp_err = 1'b1;
                    end

                    3'd3: begin // AND
                        tmp_result = a_i & b_i;
                        if ((a_i & b_i) == 4'b1111) tmp_err = 1'b1;
                    end

                    3'd4: begin // OR
                        tmp_result = a_i | b_i;
                        if ((a_i | b_i) == 4'd0) tmp_err = 1'b1;
                    end

                    default: begin
                        tmp_result = 0;
                        tmp_err = 1'b1;
                    end
                endcase

                // ЗАПАКОВКА ТА ВІДПРАВКА
                bus_out.data <= {opcode_i, a_i, b_i, tmp_err, tmp_result};
                bus_out.data_ready <= 1'b1;

            end
        end
    end

endmodule
