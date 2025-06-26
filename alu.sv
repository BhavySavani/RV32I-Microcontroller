module alu(
    input [31:0] src1,
    input [31:0] src2,
    input logic [5:0] alu_control,
    input logic [31:0] imm_val,
    output logic [31:0] alu_result,
    input [3:0] shift_amount,
    output reg [31:0] result
);

always @(*)
begin
    case(alu_control) 
        6'b000000: result = src1 + src2; // ADD
        6'b000001: result = src1 - src2; // SUB
        6'b000010: result = src1 << shift_amount; // SLL
        6'b000011: result = (src1 < src2) ? 1 : 0; // SLT
        6'b000100: result = (src1 < src2) ? 1 : 0; // SLTU
        6'b000101: result = src1 ^ src2; // XOR
        6'b000110: result = src1 >> shift_amount; // SRL
        6'b000111: result = (src1 >>> shift_amount); // SRA
        6'b001000: result = src1 | src2; // OR
        6'b001001: result = src1 & src2; // AND
        6'b001010: result = src1 + imm_val; // ADDI
        6'b001011: result = ( imm_val < src1) ? 1 : 0; // SLTI
        6'b001100: result = (imm_val << shift_amount) ;// SLLI
        6'b001101: result = (src1 < imm_val) ? 1 : 0; // SLTIU
        6'b001110: result = src1 ^ imm_val; // XORI
        6'b001111: result = src1 | imm_val; // ORI
        6'b010000: result = src1 & imm_val; // ANDI
        6'b010001: result = imm_val; // LUI
        default: result = 32'h00000000; // Default case, NOP or error state
    endcase

    alu_result = result;
end

endmodule