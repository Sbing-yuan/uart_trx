module uart_trx(
    clk,
    rst_n,
    tx,
    rx
);

input clk;
input rst_n;
input rx;
output tx;

//-----------------------------
wire bps_start1;
wire bps_start2;
wire clk_bps1;
wire clk_bps2;
wire [7:0] rx_data;
wire rx_int;
wire [6:0]  regbank_addr;
wire [7:0]  regbank_wrdata;
wire [7:0]  regbank_rddata;
wire        WRDATA_to_IDLE;
wire        RDDATA_to_IDLE;
//-----------------------------

regbank Uregbank(
                .clk(clk),
                .rst_n(rst_n),
                .regbank_addr(regbank_addr[6:0]),
                .regbank_wrdata(regbank_wrdata[7:0]),
                .regbank_rddata(regbank_rddata[7:0]),
                .wen(WRDATA_to_IDLE)
                );

regbank_ctrl regbank_ctrl(
                           .clk(clk),
                           .rst_n(rst_n),
                           .rx_data(rx_data[7:0]),
                           .rx_int(rx_int),
                           .regbank_addr(regbank_addr[6:0]),
                           .regbank_wrdata(regbank_wrdata[7:0]),
                           .WRDATA_to_IDLE(WRDATA_to_IDLE),
                           .RDDATA_to_IDLE(RDDATA_to_IDLE)
                         );

speed_select speed_rx(
                        .clk(clk),
                        .rst_n(rst_n),
                        .bps_start(bps_start1),
                        .clk_bps(clk_bps1)
                     );

speed_select speed_tx(
                        .clk(clk),
                        .rst_n(rst_n),
                        .bps_start(bps_start2),
                        .clk_bps(clk_bps2)
                     );

uart_rx uart_rx(
                .clk(clk),
                .rst_n(rst_n),
                .rx(rx),
                .rx_data(rx_data[7:0]),
                .rx_int(rx_int),
                .clk_bps(clk_bps1),
                .bps_start(bps_start1)
               );

uart_tx uart_tx(
                .clk(clk),
                .rst_n(rst_n),
                .tx_data_in(regbank_rddata[7:0]),
                .tx_trigger(RDDATA_to_IDLE),
                .tx(tx),
                .clk_bps(clk_bps2),
                .bps_start(bps_start2)
               );

endmodule
