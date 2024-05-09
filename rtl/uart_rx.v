module uart_rx(
    clk,
    rst_n,
    rx,
    rx_data,
    rx_int,
    clk_bps,
    bps_start
);

input clk;
input rst_n;
input rx;
input clk_bps;
output bps_start;
output [7:0] rx_data;
output rx_int;

//---------------------------------------------------------
reg rx0;
reg rx1;
reg rx2;
reg rx3;
always@ (posedge clk or negedge rst_n)
    if(!rst_n) begin
        rx0 <= 1'b0;
        rx1 <= 1'b0;
        rx2 <= 1'b0;
        rx3 <= 1'b0;
    end
    else begin
        rx0 <= rx;
        rx1 <= rx0;
        rx2 <= rx1;
        rx3 <= rx2;
    end

assign neg_rx = rx3 & rx2 & ~rx1 & ~rx0;

//---------------------------------------------------------
reg bps_start_r;
reg [3:0] num;
reg rx_int;

always@(posedge clk or negedge rst_n)
    if(!rst_n) begin
        bps_start_r <= 1'b0;
        rx_int <= 1'b0;
    end
    else if(neg_rx) begin
        bps_start_r <= 1'b1;
        rx_int <= 1'b1;
    end
    else if(num == 4'd9) begin
        bps_start_r <= 1'b0;
        rx_int <= 1'b0;
    end

assign bps_start = bps_start_r;

//---------------------------------------------------------
reg [7:0] rx_data_r;
reg [7:0] rx_temp_data;

always@(posedge clk or negedge rst_n)
    if(!rst_n) begin
        rx_temp_data <= 8'd0;
        num <= 4'd0;
        rx_data_r <= 8'd0;
    end
    else if(rx_int) begin
        if(clk_bps) begin
            num <= num + 1'b1;
            case(num)
                4'd1: rx_temp_data[0] <= rx;
                4'd2: rx_temp_data[1] <= rx;
                4'd3: rx_temp_data[2] <= rx;
                4'd4: rx_temp_data[3] <= rx;
                4'd5: rx_temp_data[4] <= rx;
                4'd6: rx_temp_data[5] <= rx;
                4'd7: rx_temp_data[6] <= rx;
                4'd8: rx_temp_data[7] <= rx;
                default: ;
            endcase
        end
        else if(num==4'd9) begin
            num <= 4'd0;
            rx_data_r <= rx_temp_data;
        end
    end

assign rx_data = rx_data_r;

endmodule
