module uart_tx(
    clk,
    rst_n,
    tx_data_in,
    tx_trigger,
    tx,
    clk_bps,
    bps_start
);

input clk;
input rst_n;
input clk_bps;
input[7:0] tx_data_in;
input tx_trigger;
output tx;
output bps_start;

//-------------------------------------
reg rx_int0;
reg rx_int1;
reg rx_int2;
wire neg_rx_int;

//-------------------------------------
reg [7:0]   tx_data;
reg         bps_start_r;
reg         tx_en;
reg [3:0]   num;

always@(posedge clk or negedge rst_n)
    if(!rst_n) begin
        bps_start_r <= 1'b0;
        tx_en <= 1'b0;
        tx_data <= 8'd0;
    end
    else if(tx_trigger) begin
        bps_start_r <= 1'b1;
        tx_data <= tx_data_in;
        tx_en <= 1'b1;
    end
    else if(num == 4'd10) begin
        bps_start_r <= 1'd0;
        tx_en <= 1'b0;
    end

assign bps_start = bps_start_r;

//-------------------------------------
reg tx_r;

always@(posedge clk or negedge rst_n)
    if(!rst_n) begin
        num <= 4'd0;
        tx_r <= 1'b1;
    end
    else if(tx_en) begin
        if(clk_bps) begin
            num <= num + 1'b1;
            case(num)
                4'd0: tx_r <= 1'b0;
                4'd1: tx_r <= tx_data[0];
                4'd2: tx_r <= tx_data[1];
                4'd3: tx_r <= tx_data[2];
                4'd4: tx_r <= tx_data[3];
                4'd5: tx_r <= tx_data[4];
                4'd6: tx_r <= tx_data[5];
                4'd7: tx_r <= tx_data[6];
                4'd8: tx_r <= tx_data[7];
                4'd9: tx_r <= 1'b1;
                default: tx_r <= 1'b1;
            endcase
        end
    else if(num == 4'd10) num <= 4'd0;
    end

assign tx = tx_r;

endmodule
