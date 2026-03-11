`ifndef CONFIG_DRIVER_SV
`define CONFIG_DRIVER_SV

`include "config_obj.sv"
`include "scoreboard.sv"

class ConfigDriver;
    
    ConfigObj cfg;// "Папірець" із параметрами
    virtual config_if vif;// Інтерфейс для фізичного налаштування DUT
    Scoreboard scb;// Посилання на Скорборд

    function new(virtual config_if vif, Scoreboard scb);
        this.vif = vif;// Отримує доступ до дротів (vif)
        this.scb = scb;
    endfunction

    task run();
        cfg = new();// Створення та генерація налаштувань
	// randomize() обирає випадкові значення для map0, map1, map2
        if (!cfg.randomize()) $fatal("[CONFIG] Randomization failed!");
        cfg.display();// Виводимо в консоль, що ми нагенерували
	// Ми фізично подаємо згенеровані значення на вхідні піни конфігурації
        vif.in0_to_comp = cfg.map0;
        vif.in1_to_comp = cfg.map1;
        vif.in2_to_comp = cfg.map2;

        scb.configure(cfg);//Синхронізація Скорборда
    endtask

endclass

`endif
