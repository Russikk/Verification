`ifndef GENERATOR_SV
`define GENERATOR_SV

`include "transaction.sv"

class Generator;
    
    Transaction tr;//Тимчасова зміннa для зберігання поточної транзакції, над якою йде робота.
    Transaction blueprint;//об'єкт-зразок
    
    mailbox mbx;//Канал зв'язку з Драйвером
    event done;//Подія (сигнал) синхронізації 
    int count = 0;//задає кількість тестів (транзакцій)

    function new(mailbox mbx);
        this.mbx = mbx;
        blueprint = new();
    endfunction

    task run();
        repeat(count) begin
            // рандомізуємо БЛЮПРИНТ (він існує і пам'ятає randc)
            if( !blueprint.randomize() ) $fatal("Gen: Randomization failed");
            
            // ПОТІМ робимо копію вже готових чисел у tr
            tr = blueprint.copy(); 
            
            mbx.put(tr);
            
        end
        -> done; 
    endtask

endclass

`endif
