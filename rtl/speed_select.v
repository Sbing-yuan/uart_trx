module speed_select(
    clk,
    rst_n,
    bps_start,
    clk_bps
);

input clk;
input rst_n;
input bps_start;
output clk_bps;

`define BPS 9600
`define CLK_PERIOD 20
`define BPS_SET 96
`define BPS_PARA (10_000_000/`CLK_PERIOD/`BPS_SET)
`define BPS_PARA_2 (`BPS_PARA/2)

reg [12:0] cnt;
reg clk_bps_r;

//----------------------------------------------------------
always@(posedge clk or negedge rst_n)
    if(!rst_n) cnt <= 13'd0;
    else if((cnt == `BPS_PARA) || !bps_start) cnt <= 13'd0;
    else cnt <= cnt + 1;

always@(posedge clk or negedge rst_n)
    if(!rst_n) clk_bps_r <= 1'b0;
    else if(cnt == `BPS_PARA_2) clk_bps_r <= 1'b1;
    else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule
