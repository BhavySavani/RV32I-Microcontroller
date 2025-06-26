module cu(
    input logic reset,
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    input logic [6:0] opcode,
    output reg [5:0] alu_control,
    output reg lb,
    output reg mem_to_reg,
    output reg beq_control,
    output reg bneq_control,
    output reg bgeq_control,
    output reg blt_control,
    output reg jump,
    output reg sw,
    output reg lui_control,

);

always @(reset)
begin
    if(reset) begin
    alu_control <= 6'b000000; // Default ALU control
    case(opcode)
        7'b0110011: begin // R-type instructions
            mem_to_reg <= 0;   
            beq_control <= 0;
            bneq_control <= 0;
            bgeq_control <= 0;
            blt_control <= 0;
            jump <= 0;
            lui_control <= 0;
            case(funct3)

                3'b000: alu_control <= (funct7 == 7'b0000000) ? 6'b000000 : 6'b000001; // ADD or SUB
                3'b001: alu_control <= 6'b000010; // SLL
                3'b010: alu_control <= 6'b000011; // SLT
                3'b011: alu_control <= 6'b000100; // SLTU
                3'b100: alu_control <= 6'b000101; // XOR
                3'b101: alu_control <= (funct7 == 7'b0000000) ? 6'b000110 : 6'b000111; // SRL or SRA
                3'b110: alu_control <= 6'b001000; // OR
                3'b111: alu_control <= 6'b001001; // AND
            endcase
        end

        7'b0010011: begin // I-type instructions
            case(funct3)
                3'b000: alu_control <= (funct7 == 7'b0000000) ? 6'b001010 : 6'b001011; // ADDI or SLTI
                3'b001: alu_control <= 6'b001100; // SLLI
                3'b010: alu_control <= 6'b001101; // SLTIU
                3'b011: alu_control <= (funct7 == 7'b0000000) ? 6'b001110 : 6'b001111; // XORI or ORI
                3'b100: alu_control <= (funct7 == 7'b0100000) ? 6'b010000 : 6'b010001; // ANDI or LUI
            endcase
        end

        default: begin
            alu_control <= 6'b111111; 
        end
    endcase
end
end

endmodule


