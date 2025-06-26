module pwm#(COUNTS=256,PRESCALER=0)(
    input logic clk,
    input logic reset,
    input logic [15:0] duty_cycle, // 16-bit duty cycle value
    input logic enable, // Enable signal for PWM
    output logic pwm_out // PWM output signal
);

logic [$clog2(COUNTS)-1:0] counter; // Counter for PWM

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset counter to 0
        pwm_out <= 0; // Reset PWM output to low
    end else if (enable) begin
        if (counter < COUNTS - 1) begin
            counter <= counter + 1; // Increment counter
        end else begin
            counter <= 0; // Reset counter when it reaches COUNTS
        end
        
    end
end

always @(posedge clk) begin
    if (enable) begin
        if (counter > PRESCALER && counter < (duty_cycle * COUNTS)/100) begin 
            pwm_out <= 1; // Set PWM output high
        end else begin
            pwm_out <= 0; // Set PWM output low
        end
    end else begin
        pwm_out <= 0; // If not enabled, set PWM output low
    end
end
endmodule
