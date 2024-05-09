initial begin
    wait(pat_start == 1);

    read(7'd0);
    read(7'd1);
    read(7'd2);
    read(7'd3);

    write(7'd0, 8'h5A);
    write(7'd1, 8'hFF);
    write(7'd2, 8'h00);
    write(7'd3, 8'hA5);
    #2000;
    //uart_write(8'h5A);
    //uart_write(8'hA5);
    //uart_write(8'h0F);
    //uart_write(8'hF0);
    read(7'd0);
    read(7'd1);
    read(7'd2);
    read(7'd3);
    $display("[TestTop] Finished");
    $finish;
end
