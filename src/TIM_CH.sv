module TIM_CH(
    input logic [15:0] TIM_CNT,
    input logic en,
    input logic [15:0] CCR,
    output logic pwm_out // PWM output signal
);

assign pwm_out = (TIM_CNT < CCR) ? (1'b1 && en) : 1'b0; // Generate PWM signal based on TIM_CNT and CCR
endmodule