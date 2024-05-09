module regbank_ctrl(
    clk,
    rst_n,
    rx_data,
    rx_int,
    regbank_addr,
    regbank_wrdata,
    WRDATA_to_IDLE,
    RDDATA_to_IDLE
);

input clk;
input rst_n;
input [7:0] rx_data;
input rx_int;
output [6:0] regbank_addr;
output [7:0] regbank_wrdata;
output WRDATA_to_IDLE;
output RDDATA_to_IDLE;

//---------------------------------------------------
parameter ST_IDLE = 0;
parameter ST_WRADDR = 1;
parameter ST_WRDATA = 2;
parameter ST_RDADDR = 3;
reg [1:0] state_cs;
reg [1:0] state_ns;
reg       rx_int_d;
reg       load_wrdata_d;
reg       tx_trigger_d;
reg [6:0] regbank_addr;
reg [7:0] regbank_wrdata;

wire rx_int_f = rx_int_d & ~rx_int;
wire load_addr = (state_cs == ST_IDLE) && ((state_ns == ST_WRADDR) || (state_ns == ST_RDADDR));
wire load_wrdata = (state_cs == ST_WRADDR) && (state_ns == ST_WRDATA);
wire tx_trigger = (state_cs == ST_IDLE) && (state_ns == ST_RDADDR);
wire WRDATA_to_IDLE = load_wrdata_d;
wire RDDATA_to_IDLE = tx_trigger_d; 

always@(posedge clk or negedge rst_n)
    if(!rst_n) rx_int_d <= 0;
    else       rx_int_d <= rx_int;

always@(posedge clk or negedge rst_n)
    if(!rst_n) state_cs <= ST_IDLE;
    else       state_cs <= state_ns;

always@(posedge clk or negedge rst_n)
    if(!rst_n)          regbank_addr <= 7'd0;
    else if(load_addr)  regbank_addr <= rx_data[6:0];

always@(posedge clk or negedge rst_n)
    if(!rst_n)            regbank_wrdata <= 8'd0;
    else if(load_wrdata)  regbank_wrdata <= rx_data[7:0];

always@(posedge clk or negedge rst_n)
    if(!rst_n)  load_wrdata_d <= 1'd0;
    else        load_wrdata_d <= load_wrdata;

always@(posedge clk or negedge rst_n)
    if(!rst_n) tx_trigger_d <= 0;
    else       tx_trigger_d <= tx_trigger;

always@(*)
begin
    state_ns = state_cs;
    case(state_cs)
        ST_IDLE:
        begin
            if(rx_int_f)
            begin
                if(rx_data[7] == 1'b1) state_ns = ST_WRADDR;
                else                   state_ns = ST_RDADDR;
            end
        end
        ST_WRADDR:
        begin
            if(rx_int_f)
                state_ns = ST_WRDATA;
        end
        ST_WRDATA:
        begin
            if(WRDATA_to_IDLE)
                state_ns = ST_IDLE;
        end
        ST_RDADDR:
        begin
            if(RDDATA_to_IDLE)
                state_ns = ST_IDLE;
        end
        default:;
    endcase
end


endmodule
