`ifndef COVERAGE_COLLECTOR_SV
`define COVERAGE_COLLECTOR_SV

class coverage_collector extends uvm_subscriber #(Transaction);
    `uvm_component_utils(coverage_collector)

    Transaction tr;
    int channel_id;

    // Описуємо covergroup
    covergroup alu_cg;
        option.per_instance = 1;
        option.name = $sformatf("alu_coverage_ch_%0d", channel_id);

        // Покриття операцій
        cp_opcode: coverpoint tr.opcode {
            bins math      = {3'd0, 3'd1};     // ADD, SUB
            bins bitwise   = {3'd2, 3'd3, 3'd4}; // XOR, AND, OR
            bins others    = { [5:7] };        
        }

        // Покриття значень операндів (Boundary values)
        cp_a: coverpoint tr.a {
            bins zero = {0};
            bins max  = {15};
            bins range[4] = { [1:14] }; // Розбиваємо на 4 кошики
        }

        cp_b: coverpoint tr.b {
            bins zero = {0};
            bins max  = {15};
            bins range[4] = { [1:14] };
        }

        // Кросс-покриття: кожна операція з кожним діапазоном А
        cross_op_a: cross cp_opcode, cp_a;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        alu_cg = new();
    endfunction

    // Цей метод викликається автоматично, коли монітор надсилає транзакцію
    virtual function void write(Transaction t);
        this.tr = t;
        alu_cg.sample();
    endfunction

endclass

`endif
