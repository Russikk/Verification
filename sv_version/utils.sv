`ifndef UTILS_SV
`define UTILS_SV

function void print_test_header(string name);
    $display("\n>>> TEST: %s", name);
    $display("----------------------------------------------------------------");
endfunction

function void print_test_summary(int p, int f, string name = "Scoreboard");
    $display("\n================================================================");
    $display(" REPORT: %s", name);
    $display(" STATUS: %s", (f == 0 && (p + f) > 0) ? "PASSED" : "FAILED");
    $display(" TOTAL : %0d | PASSED: %0d | FAILED: %0d", (p + f), p, f);
    $display("================================================================\n");
endfunction

`endif
