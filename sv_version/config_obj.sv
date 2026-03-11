`ifndef CONFIG_OBJ_SV
`define CONFIG_OBJ_SV

class ConfigObj;
    //Змінні конфігурації
    rand bit [1:0] map0;
    rand bit [1:0] map1;
    rand bit [1:0] map2;

    //Обмеження діапазону, (0, 1, 2)
    constraint range_c {
        map0 inside {[0:2]};
        map1 inside {[0:2]};
        map2 inside {[0:2]};
    }

    //Обмеження унікальності, всі значення в наборі мають бути різними
    constraint unique_c {
        unique {map0, map1, map2};
    }
    
    function void display();
        $display("[CONFIG] Map: In0->%0d, In1->%0d, In2->%0d", map0, map1, map2);
    endfunction

endclass

`endif
