module TIM#()(
    input logic clk,
    input logic en,
    input wire countdown,
    input logic [15:0] TIM_PSC,
    input logic [15:0] TIM_ARR,
    input logic [15:0] TIM_CCR1,
    input logic [15:0] TIM_CCR2,
    output logic [15:0] TIM_CNT, // 32-bit timer value
    output logic timer_interrupt,// Timer done signal
    output logic pwm_out_1,
    output logic pwm_out_2 
);

logic [15:0] counter;// 16-bit counter
reg clk_out;
initial begin
    TIM_CNT = 0;
    timer_interrupt = 0;
    clk_out = 1; 
end
reg[14:0] counts ;
assign counts= (TIM_PSC>>1)-1;
always@(posedge en) begin
        counter <= 0;
        TIM_CNT <= 8'h00;
        timer_interrupt <= 0;
        clk_out <= 0;
    end
TIM_CH pwm1(TIM_CNT,en,TIM_CCR1,pwm_out_1);
TIM_CH pwm2(TIM_CNT,en,TIM_CCR2,pwm_out_2);

always@(posedge clk) begin
    // Reset clk_out on every clock edge
    if(en) begin
        if(counter == counts)
        begin
            clk_out <= ~clk_out;
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
end

always@(posedge clk_out) begin
    if(!countdown)
        TIM_CNT <= TIM_CNT + 1;
    else
        TIM_CNT <= TIM_CNT - 1;
end

always@(posedge clk_out) begin
    if(TIM_CNT == TIM_ARR) begin
        TIM_CNT <= 0; // Reset timer value when it reaches ARR
        timer_interrupt <= 1; // Set interrupt when timer reaches ARR value
    end else begin
        timer_interrupt <= 0; // Clear interrupt otherwise
    end
end
endmodule