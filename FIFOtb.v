`timescale 1ns/1ps

module tb_easy_fifo;

    reg clk, rst, write, read;
    reg [7:0] din;
    wire [7:0] dout;
    wire fifo_full, fifo_empty;

    easy_fifo uut (
        .clk(clk),
        .rst(rst),
        .write(write),
        .read(read),
        .din(din),
        .dout(dout),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        write = 0;
        read = 0;
        din = 0;
        #10 rst = 0;
        repeat (5) begin
            @(posedge clk);
            write = 1;
            din = din + 8'h11;
        end
        @(posedge clk);
        write = 0;
        repeat (3) begin
            @(posedge clk);
            read = 1;
        end
        @(posedge clk);
        read = 0;
        repeat (3) begin
            @(posedge clk);
            write = 1;
            din = din + 8'h22;
        end
        @(posedge clk);
        write = 0;
        while (!fifo_empty) begin
            @(posedge clk);
            read = 1;
        end
        @(posedge clk);
        read = 0;
        #20 $finish;
    end

    initial begin
        $monitor("Time=%0t | Write=%b Read=%b | Din=%h Dout=%h | Full=%b Empty=%b | Count=%d", 
                 $time, write, read, din, dout, fifo_full, fifo_empty, uut.count);
    end

endmodule
