module fifo_sync #(
    parameter DEPTH = 8,
    parameter WIDTH = 4
)(
    input [3:0] data_in,
    input       reset,
                read,
                write,
                clk,
    output reg [3:0] data_out,
    output reg       empty,
                     full
);
    reg [2:0] rd_ptr,
              wr_ptr;
    reg [WIDTH-1:0] memory [DEPTH-1:0];

    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            empty <= 1;
            full <= 0;
            rd_ptr <= 0;
            wr_ptr <= 0;
        end else begin
            if(read & !empty) begin
                data_out <= memory[rd_ptr];
                full <= 0;

                if(rd_ptr < DEPTH-1)
                    rd_ptr <= rd_ptr + 1;
            end else if (write & !full) begin
                memory[wr_ptr] <= data_in;
                empty <= 0;    
                
                if(wr_ptr == DEPTH-1)
                    full <= 1;
                else    
                    wr_ptr = wr_ptr + 1;
                
            end
        end
    end 
endmodule


