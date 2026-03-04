`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "transaction.sv"
`include "config_obj.sv"
`include "cbs.sv"

class Scoreboard extends MonitorCallback;//Успадкування від абстрактного класу MonitorCallback, Клас Scoreboard є різновидом MonitorCallback 
    
    ConfigObj cfg;
    
    int passed = 0;
    int failed = 0;
    bit configured = 0;// Прапорець стану ініціалізації

    function new();//цей клас створюється без аргументів
    endfunction

    // Метод для завантаження налаштувань.
    // Викликається з ConfigDriver перед початком тестів, щоб Скорборд знав,
    // за якою логікою (картою) зараз працює DUT.
    function void configure(ConfigObj cfg_obj);
        this.cfg = cfg_obj;
        configured = 1;
        $display("[SCOREBOARD] Config received via Callback! In0->%0d", cfg.map0);
    endfunction


    virtual function void write(Transaction tr); //Це метод, через який Скорборд отримує транзакцію для перевірки
        bit [3:0] predicted_result;
        
        if (!configured) begin// Захист від запуску перевірки до завершення налаштування середовища
            $display("[SCOREBOARD] Warning: Data received before configuration!");
            return;
        end

        // Golden Model
        case (tr.opcode)
            0: predicted_result = tr.a + tr.b; 
            1: predicted_result = tr.a - tr.b; 
            2: predicted_result = tr.a ^ tr.b; 
            3: predicted_result = tr.a & tr.b; 
            4: predicted_result = tr.a | tr.b; 
            default: predicted_result = 0;
        endcase
	// Порівняння
        if (tr.result == predicted_result) begin
            passed++;
        end else begin
            failed++;
            $error("[SCOREBOARD] Error! Op=%0d. Actual:%0d Expected:%0d",
                    tr.opcode, tr.result, predicted_result);
        end
    endfunction

    task run();

    endtask

    function void report();
        $display("\n----------------------------------------------------------------");
        $display("                     TEST SUMMARY                               ");
        $display("----------------------------------------------------------------");
        $display(" Total Tests : %0d", passed + failed);
        $display(" Passed      : %0d", passed);
        $display(" Failed      : %0d", failed);
        $display("----------------------------------------------------------------");
        if (failed == 0) $display(" RESULT      : TEST PASSED ✅");
        else             $display(" RESULT      : TEST FAILED ❌");
        $display("----------------------------------------------------------------\n");
    endfunction

endclass

`endif
