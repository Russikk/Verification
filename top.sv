`include "environment.sv"
`include "test_lib.sv"

module top;

    logic clk;
    logic rst;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20 rst = 0;
    end
    // Створюємо фізичні екземпляри інтерфейсів для кожного порту DUT
    simple_if intf_in_0(clk);
    simple_if intf_out_0(clk);
    simple_if intf_out_1(clk);
    simple_if intf_out_2(clk);
    simple_if intf_in_1(clk);
    simple_if intf_in_2(clk);
    config_if cfg_intf();

    dut u_dut (
        .clk             (clk),
        .rst             (rst),
        .cfg             (cfg_intf),
        .simple_if_in_0  (intf_in_0),
        .simple_if_in_1  (intf_in_1),
        .simple_if_in_2  (intf_in_2),
        .simple_if_out_0 (intf_out_0),
        .simple_if_out_1 (intf_out_1),
        .simple_if_out_2 (intf_out_2)
    );

    Environment env;// Оголошуємо змінну середовища
    
    // Оголошуємо змінні для спеціальних тестів
    Transaction_Arithmetic tr_arith;
    Transaction_Logic      tr_logic;
    Transaction_Reserved   tr_reserved;

    initial begin
	// Примусово занулюємо порти, які не беруть участі в тесті
        intf_in_1.data = '0; intf_in_1.data_ready = 0;
        intf_in_2.data = '0; intf_in_2.data_ready = 0;
        #30;

        $display("\n===========================================");
        $display("   RUNNING TEST 1: ARITHMETIC ONLY");
        $display("===========================================");
        
        env = new(intf_in_0, intf_out_0, intf_out_1, intf_out_2, cfg_intf);// Створюємо середовище і передаємо йому віртуальні інтерфейси
        
        tr_arith = new();// Створюємо "Арифметичний шаблон"
        env.gen.blueprint = tr_arith;// Тепер усі згенеровані транзакції будуть мати opcode {0, 1}
        env.gen.count = 5000;
        
        env.run();// Запускаємо тест і чекаємо його завершення (блокуючий виклик)

        #100;
        $display("\n===========================================");
        $display("   RUNNING TEST 2: LOGIC ONLY");
        $display("===========================================");

        env = new(intf_in_0, intf_out_0, intf_out_1, intf_out_2, cfg_intf);
        
        tr_logic = new();
        env.gen.blueprint = tr_logic;
        env.gen.count = 5000;
        
        env.run();

        #100;
        $display("\n========================================");
        $display(" RUNNING TEST 3: RESERVED OPCODES (ERROR INJECTION)");
        $display("========================================");
    
        // Перестворюємо середовище для чистого запуску
        env = new(intf_in_0, intf_out_0, intf_out_1, intf_out_2, cfg_intf);
    
        // Створюємо шаблон транзакції з помилками
        tr_reserved = new();
    
        // Завантажуємо шаблон у генератор
        env.gen.blueprint = tr_reserved;
    
       // Встановлюємо кількість ітерацій (наприклад, 200 достатньо для 3 кодів)
       env.gen.count = 200; 
    
       // Запускаємо тест
       env.run();


        
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule
