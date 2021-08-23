module fifo_circular #(
    parameter DEPTH = 8,
    parameter WIDTH = 4
)(
    input [3:0] data_in,
    input       reset,
                read,
                write,
                rd_clk,
                wr_clk,
    output reg [3:0] data_out,
    output reg       empty,
    output           full
);
    reg [2:0] rd_ptr,
              wr_ptr;
    reg [WIDTH-1:0] memory [DEPTH-1:0];

    assign full = !empty && (rd_ptr == wr_ptr) && reset;

    always @ (posedge (rd_clk & read & !empty) or negedge reset) begin
        if(!reset) begin
            empty = 1;
            rd_ptr = 0;
        end else begin    
            data_out = memory[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            empty = !full && (rd_ptr == wr_ptr);
        end
    end

    always @ (posedge (wr_clk & write & !full) or negedge reset) begin
        if(!reset) begin
            wr_ptr = 0;
        end else begin
            memory[wr_ptr] <= data_in;
            wr_ptr = wr_ptr + 1;
            empty = 0;
        end
    end    
endmodule:fifo_circular

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