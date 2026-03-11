`ifndef CBS_SV
`define CBS_SV

`include "transaction.sv"

virtual class MonitorCallback;
    // Абстрактний метод (без реалізації)
    // Він встановлює єдиний стандарт "вхідного порту" для всіх модулів
    // Монітор знатиме, що у всіх підписників точно є функція з ім'ям 'write'
    pure virtual function void write(Transaction tr);
endclass

`endif
