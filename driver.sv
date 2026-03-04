class Driver;
    
    mailbox mbx;// Канал зв'язку для отримання транзакцій

    virtual simple_if vif;// Віртуальний інтерфейс для доступу до сигналів DUT

    function new(mailbox mbx, virtual simple_if vif);
        this.mbx = mbx;
        this.vif = vif;
    endfunction

    task run();
        $display("[DRIVER] Started...");
        
        forever begin
            Transaction tr;
            mbx.get(tr);// Блокуючий метод: очікує появи транзакції у скриньці

            $display("[DRIVER] Sending: Op=%0d A=%0d B=%0d", tr.opcode, tr.a, tr.b);
 
            @(negedge vif.clk);

            vif.data = {tr.opcode, tr.a, tr.b, 5'b0};
            vif.data_ready = 1; 

            @(negedge vif.clk);

            vif.data_ready = 0;
            vif.data       = 0;

        end
    endtask

endclass
