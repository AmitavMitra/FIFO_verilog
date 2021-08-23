`include "fifo_circular.v"

module fifo_circular_tb;
    reg [3:0] data_in;
    reg       reset,
              read,
              write,
              rd_clk,
              wr_clk;
    wire [3:0] data_out;
    wire       empty,
               full;
    fifo_async ffs (data_in, reset, read, write, rd_clk, wr_clk, data_out, empty, full);
    initial $monitor("WRITE=%b\t READ=%b\t DATA IN:%d\t DATA OUT:%d\t FULL:%s\t EMPTY:%s", 
                        write, read, data_in, data_out, full?"YES":"NO", empty?"YES":"NO");
    always #6 rd_clk = ~rd_clk;
    always #3 wr_clk = ~wr_clk;
    initial begin
        $display("Circular FIFO\n");
        rd_clk=1'b0; wr_clk=1'b0;
        #5 reset=1'b0;
        #5 reset=1'b1;
        #5 write=1'b1; read=1'b0;
        #5 data_in=1;
        #5 data_in=2;
        #5 data_in=3;
        #5 data_in=5;
        #5 data_in=5;
        #5 data_in=6;
        #5 data_in=7;
        #5 data_in=8;
        #5 write=1'b0; read=1'b1;
        
    end
endmodule:fifo_circular_tb