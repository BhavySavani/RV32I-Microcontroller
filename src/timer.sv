module timer#()(
    input logic clk,
    input logic en,
    input wire countdown,
    input logic [15:0] TIM_PSC,
    input logic [15:0] TIM_ARR,
    output logic [31:0] timer_value, // 32-bit timer value
    output logic timer_interrupt // Timer done signal
);

logic [15:0] counter; // 16-bit counter
initial begin
    timer_value = 0;
    timer_interrupt = 0;
    clk_out = 1; 
end
localparam counts= TIM_PSC/2;
always@(posedge en) begin
        counter <= 0;
        timer_value <= 0;
        timer_interrupt <= 0;
        clk_out <= 0;
    end


always@(posedge clk) begin
    // Reset clk_out on every clock edge
    if(en) begin
        if(counter < counts)
        begin
            counter <= counter + 1;
        end
        else begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
    end
end

always@(posedge clk_out) begin
    if(!countdown)
        timer_value <= timer_value + 1;
    else
        timer_value <= timer_value - 1;
end

always@(posedge clk_out) begin
    if(timer_value == TIM_ARR) begin
        timer_value <= 0; // Reset timer value when it reaches ARR
        timer_interrupt <= 1; // Set interrupt when timer reaches ARR value
    end else begin
        timer_interrupt <= 0; // Clear interrupt otherwise
    end
end
endmodule