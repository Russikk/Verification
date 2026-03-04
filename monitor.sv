`ifndef MONITOR_SV
`define MONITOR_SV

`include "transaction.sv"
`include "cbs.sv"

class Monitor;
    
    virtual simple_if vif; // Віртуальний інтерфейс для доступу до фізичних сигналів
    
    MonitorCallback cbs[$];// Динамічний масив об'єктів-слухачів для реалізації Observer pattern

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    function void add_callback(MonitorCallback cb);// Функція дозволяє зовнішнім об'єктам (Environment) додати себе в список розсилки
        cbs.push_back(cb);// Метод push_back додає елемент у кінець черги
    endfunction

    task run();
        forever begin
            @(posedge vif.clk);
            if (vif.data_ready) begin
                Transaction tr = new();
                
                tr.opcode = vif.data[15:13];
                tr.a      = vif.data[12:9];
                tr.b      = vif.data[8:5];
                tr.error  = vif.data[4];
                tr.result = vif.data[3:0];

                foreach (cbs[i]) begin
                    Transaction tr_copy = tr.copy();//Створюємо незалежну копію транзакції для кожного підписника
                    cbs[i].write(tr_copy);// Виклик методу write() у конкретного підписника
                end
            end
        end
    endtask

endclass

`endif
