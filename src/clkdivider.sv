module clkdivider#(DIVISOR=4)(
    input logic clk,
    input logic reset,
    output logic clk_out
);

initial begin
        clk_out = 0; 
end

reg [$clog2(DIVISOR)-2:0] counter;
reg counts = DIVISOR/2;
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        if (counter < counts) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            clk_out <= ~clk_out; 
        end
    end
end

endmodule
    