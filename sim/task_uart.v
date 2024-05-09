parameter BPS = 9600;
parameter Tbps = 1000_000_000/BPS;
parameter Tbps_2 = Tbps/2;

reg tb_tx;
reg [7:0] tb_rw_addr;
reg [7:0] tb_rddata;

initial begin
    tb_tx = 1;
end

task host_uart_write(input reg [7:0] byte);
begin
    tb_tx = 1'b0; // start  bit
    #Tbps; tb_tx = byte[0];
    #Tbps; tb_tx = byte[1];
    #Tbps; tb_tx = byte[2];
    #Tbps; tb_tx = byte[3];
    #Tbps; tb_tx = byte[4];
    #Tbps; tb_tx = byte[5];
    #Tbps; tb_tx = byte[6];
    #Tbps; tb_tx = byte[7];
    #Tbps; tb_tx = 1'b1;
    #Tbps; 
end
endtask

task write(input reg [6:0] addr, input reg [7:0] data);
begin
    tb_rw_addr = {1'b1, addr[6:0]};
    $display("[TestTop] write_reg addr: %3d, data: %3d", addr, data);
    host_uart_write(tb_rw_addr[7:0]);
    host_uart_write(data[7:0]);
end
endtask

task read(input reg [6:0] addr);
begin
fork
    begin
        tb_rw_addr = {1'b0, addr[6:0]};
        $display("[TestTop] read_reg addr: %3d", addr);
        host_uart_write(tb_rw_addr[7:0]);
    end
    begin
        @(negedge TestTop.tx); // start
        #Tbps_2; 
        #Tbps;  tb_rddata[0] = TestTop.tx;
        #Tbps;  tb_rddata[1] = TestTop.tx;
        #Tbps;  tb_rddata[2] = TestTop.tx;
        #Tbps;  tb_rddata[3] = TestTop.tx;
        #Tbps;  tb_rddata[4] = TestTop.tx;
        #Tbps;  tb_rddata[5] = TestTop.tx;
        #Tbps;  tb_rddata[6] = TestTop.tx;
        #Tbps;  tb_rddata[7] = TestTop.tx;
        $display("[TestTop] read data: %3d", tb_rddata);
    end
join
end
endtask
