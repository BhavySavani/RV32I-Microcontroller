module alu(
    input [31:0] src1,
    input [31:0] src2,
    input logic [5:0] alu_cntrl,
    input logic [31:0] imm_val,
    input [3:0] shift_amount,
    output reg [31:0] result
);

always @(*)
begin
    case(alu_cntrl) 
        6'b000000: result = src1 + src2; // ADD
        6'b000001: result = src1 - src2; // SUB
        6'b000010: result = src1 << src2; // SLL
        6'b000011: result = ($signed(src1) < $signed(src2)) ? 1 : 0; // SLT
        6'b000100: result = (src1 < src2) ? 1 : 0; // SLTU
        6'b000101: result = src1 ^ src2; // XOR
        6'b000110: result = src1 >> src2; // SRL
        6'b000111: result = signed'(src1) >>> src2; // SRA
        6'b001000: result = src1 | src2; // OR
        6'b001001: result = src1 & src2; // AND
        6'b001010: result = src1 + imm_val; // ADDI
        6'b001011: result = (imm_val << shift_amount) ;// SLLI
        6'b001100: result = ( $signed(imm_val) < $signed(src1)) ? 1 : 0; // SLI
        6'b001101: result = ((imm_val<<1) < src1) ? 1 : 0; // SLTU
        6'b001111: result = src1 >> imm_val; // SRLI
        6'b001110: result = src1 ^ imm_val; // XORI
        6'b010000: result = src1 | imm_val; // ORI
        6'b010001: result = src1 & imm_val; // ANDI
        6'b010010: result = imm_val<<12; // LUI
	    6'b010111: result = src2[7:0];//SB
	    6'b011000: result = src2[15:0];//SH
        6'b011001: result = src2;//SW
        6'b011010: result =  (src1 == src2) ? 1 : 0; //BEQ
        6'b011011: result = (src1 != src2) ? 1 : 0; //BNEQ
        6'b011101: result = (src2 >= src1) ? 1 : 0 ; //BGEQ
        6'b011100: result = (src1 < src2) ? 1 : 0 ;//BLT
        default: result = 32'h00000000; // Default case, NOP or error state
    endcase

end

endmodule
