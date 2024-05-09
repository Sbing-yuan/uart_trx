`timescale 1ns / 1ps

module TestTop;

`include "TestDef.v"
`include "task_uart.v"

reg clk;
reg rst_n;
reg rx;
reg pat_start;
wire tx;
//-----------------------------
always #10 clk = ~clk; // 50MHz

initial begin
    clk = 0;
    pat_start = 0;
    rst_n = 1;
    rx = 0;
    #1;
    rst_n = 0;
    $display("[TestTop] Test Start");
    #200;
    $display("[TestTop] rst_n released");
    rst_n = 1;
    #200;

    $display("[TestTop] Start test pattern");
    pat_start = 1;
end

`include "testvec.v"

uart_trx U_uart_trx(
    .clk(clk),
    .rst_n(rst_n),
    .tx(tx),
    .rx(tb_tx)
);

`ifdef VCDDUMP
initial begin
    $dumpfile("Test.vcd");  //
    $dumpvars(0,TestTop);       
end
`endif

endmodule
