`ifndef SUBSCRIBER_SV
`define SUBSCRIBER_SV

`include "transaction.sv"
`include "cbs.sv"

class Subscriber extends MonitorCallback;// Успадковує інтерфейс MonitorCallback для отримання даних від монітора
    
    Transaction tr;// Локальний об'єкт транзакції
    
    covergroup cg;//Оголошення групи функціонального покриття (Covergroup)
        cp_opcode: coverpoint tr.opcode {// Слідкуємо за змінною tr.opcode
            bins add = {0};//Якщо бачиш 0, поклади +1 у кошик 'add'
            bins sub = {1};
            bins xor_op = {2};
            bins and_op = {3};
            bins or_op = {4};
            illegal_bins bad = {5, 6, 7};// Якщо прийде 5, 6 або 7, симулятор зупинить тест і видасть помилку
        }
        cp_a: coverpoint tr.a;//створити автоматично по одному 'кошику' для кожного числа, яке може бути в цій змінній
        cp_b: coverpoint tr.b;
        cp_err: coverpoint tr.error;
        cross_op_err: cross cp_opcode, cp_err;//Перехресне покриття, наприклад: Чи була помилка при додаванні?
        cross_op_a_b: cross cp_opcode, cp_a, cp_b;
    endgroup

	// covergroup cg — це лише "креслення"
        // Щоб воно запрацювало, ми повинні явно створити (ініціалізувати) його в пам'яті
    function new();
        cg = new(); 
    endfunction

    virtual function void write(Transaction tr);//приймає нові дані від Монітора і дає команду covergroup врахувати ці дані в загальному звіті
        this.tr = tr; 
        cg.sample();//Це метод, який оновлює лічильники bins на основі поточних значень змінних.
    endfunction

    task run();
    endtask

endclass

`endif
