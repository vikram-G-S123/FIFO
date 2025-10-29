module easy_fifo (
    input clk,
    input rst,
    input write,
    input read,
    input [7:0] din,
    output reg [7:0] dout,
    output fifo_full,
    output fifo_empty
);

    reg [7:0] mem [0:7];   
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] count;

    assign fifo_full  = (count == 8);
    assign fifo_empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;
        end else begin
            if (write && !fifo_full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            if (read && !fifo_empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end

endmodule
