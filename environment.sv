`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

`include "transaction.sv"
`include "cbs.sv" 
`include "config_obj.sv"
`include "config_driver.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "subscriber.sv"

class Environment;
    
    Generator    gen;
    Driver       drv;

    // У нас три монітори, оскільки DUT має три вихідні порти (або режими)
    Monitor      mon0;
    Monitor      mon1;
    Monitor      mon2;

    Scoreboard   scb;
    Subscriber   cov;
    ConfigDriver cfg_drv;

    mailbox gen2drv;// Поштова скринька для передачі транзакцій від Generator до Driver

    // Віртуальні інтерфейси
    virtual simple_if vif_in;
    virtual simple_if vif_out0;
    virtual simple_if vif_out1;
    virtual simple_if vif_out2;
    virtual config_if vif_cfg;

     // Сюди передаються інтерфейси з верхнього рівня (Top module)
    function new(virtual simple_if vif_in, 
                 virtual simple_if vif_out0, 
                 virtual simple_if vif_out1, 
                 virtual simple_if vif_out2, 
                 virtual config_if vif_cfg);
        // Прив'язка інтерфейсів
        this.vif_in   = vif_in;
        this.vif_out0 = vif_out0;
        this.vif_out1 = vif_out1;
        this.vif_out2 = vif_out2;
        this.vif_cfg  = vif_cfg;
        
        gen2drv = new();//Створюємо скриньку

        // передаємо mailbox або інтерфейси в конструктори підмодулів
        gen = new(gen2drv);
        drv = new(gen2drv, vif_in);

        // Кожен монітор прив'язується до свого фізичного інтерфейсу
        mon0 = new(vif_out0);
        mon1 = new(vif_out1);
        mon2 = new(vif_out2);
        
        scb = new();
        cov = new();
        
        // Куди б не пішли дані (на вихід 0, 1 чи 2), Скорборд їх отримає
        mon0.add_callback(scb); mon0.add_callback(cov);
        mon1.add_callback(scb); mon1.add_callback(cov);
        mon2.add_callback(scb); mon2.add_callback(cov);
        
        // Створення конфігураційного драйвера
        // Йому передаємо scb, щоб він повідомив Скорборду, яка зараз карта виходів активна
        cfg_drv = new(vif_cfg, scb); 
    endfunction

    task test();
        cfg_drv.run();// Запускаємо конфігурацію ПЕРЕД початком основного трафіку
        
        fork//Паралельний запуск верифікації
            gen.run();
            drv.run();
            mon0.run();
            mon1.run();
            mon2.run();
            cov.run();
        join_none// Не чекаємо завершення

        wait(gen.done.triggered);// Чекаємо, поки генератор виставить подію done
        #10000000; 
        
    endtask

    task run();
        test();
    endtask

endclass

`endif
