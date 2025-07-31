module cu(
    input logic reset,
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    input logic [6:0] opcode,
    output reg [5:0] alu_cntrl,
    output reg lb,
    output reg mem_to_reg,
    output reg bneq_cntrl,
    output reg beq_cntrl,
    output reg bgeq_cntrl,
    output reg blt_cntrl,
    output reg jump,
    output reg sw,
    output reg lui_cntrl,
    output reg timer_en
);

always @(*)//reset or opcode or funct3 or funct7
begin
     // Default to an invalid/error state
    lb = 1'b0;
    mem_to_reg = 1'b0;
    bneq_cntrl = 1'b0;
    beq_cntrl = 1'b0;
    bgeq_cntrl = 1'b0; // Default bgeq_cntrl to 0
    blt_cntrl = 1'b0;
    jump = 1'b0;
    sw = 1'b0;
    lui_cntrl = 1'b0;
    
    
    if(reset) begin
    	alu_cntrl <= 6'b111111; // Default ALU cntrl
    end
    
    else begin
    case(opcode)
        7'b0110011: begin // R-type instructions
            mem_to_reg <= 0;   
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
            bgeq_cntrl <= 0;
            blt_cntrl <= 0;
            jump <= 0;
            lui_cntrl <= 0;
            case(funct3)
                3'b000: alu_cntrl <= (funct7 == 7'b0000000) ? 6'b000000 : 6'b000001; // ADD or SUB
                3'b001: alu_cntrl <= 6'b000010; // SLL
                3'b010: alu_cntrl <= 6'b000011; // SLT
                3'b011: alu_cntrl <= 6'b000100; // SLTU
                3'b100: alu_cntrl <= 6'b000101; // XOR
                3'b101: alu_cntrl <= (funct7 == 7'b0000000) ? 6'b000110 : 6'b000111; // SRL or SRA
                3'b110: alu_cntrl <= 6'b001000; // OR
                3'b111: alu_cntrl <= 6'b001001; // AND
            endcase
        end

        7'b0010011: begin // I-type instructions
            mem_to_reg <= 0;
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
            bgeq_cntrl <= 0;
            blt_cntrl <= 0;
            jump <= 0;
            lb <= 0;
            sw <= 0;
            case(funct3)
                3'b000: alu_cntrl <= 6'b001010; // ADDI
                3'b001: alu_cntrl <= 6'b001011; // SLLI
                3'b010: alu_cntrl <= 6'b001100; // SLI
                3'b011: alu_cntrl <= 6'b001101; // SLTU
                3'b100: alu_cntrl <= 6'b001110; // XORI
                3'b101: alu_cntrl <= 6'b001111; // SRLI
                3'b110: alu_cntrl <= 6'b010000; // ORI
                3'b111: alu_cntrl <= 6'b010001; // ANDI
            endcase
        end
        7'b0000011: begin
	    mem_to_reg <= 1;
            lb <= 1;
            sw <= 0;
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
            bgeq_cntrl <= 0;
            blt_cntrl <= 0;
            jump <= 0;
            lui_cntrl <= 0;
            case(funct3)
                3'b000: begin
                    alu_cntrl <= 6'b010010; // Load Byte
                    
                end
                3'b001: begin // LH
                    alu_cntrl <= 6'b010011; // Load Halfword
                end
                3'b010: begin // LW
                    alu_cntrl <= 6'b010100; // Load Word
                    
                end
                3'b100: begin // LBU
                    alu_cntrl <= 6'b010101; // Load Byte Unsigned
                    
                end
                3'b101: begin // LHU
                    alu_cntrl <= 6'b010110; // Load Halfword Unsigned
                    
                end
            endcase
        end
        7'b0100011: begin // S-type instructions
            mem_to_reg <= 0;
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
	    bgeq_cntrl <= 0;
            blt_cntrl <= 0;
            jump <= 0;
            lui_cntrl <= 0;
            lb <= 0;
            sw <= 1; // Store Word
            case(funct3)
                3'b000: alu_cntrl <= 6'b010111; // SB
                3'b001: alu_cntrl <= 6'b011000; // SH
                3'b010: alu_cntrl <= 6'b011001; // SW
            endcase
        end
        7'b1100011: begin // B-type instructions
	    mem_to_reg <= 0;
            jump <= 0;
            lui_cntrl <= 0;
            lb <= 0;
            sw <= 0;
            case(funct3)
                3'b000: begin
	            bgeq_cntrl <= 0;
                    blt_cntrl <= 0;
                    beq_cntrl <= 1;
                    bneq_cntrl <= 0;
                    alu_cntrl <= 6'b011010; // BEQ
                end
                3'b001: begin
                    beq_cntrl <= 0;
                    bneq_cntrl <= 1;
                    bgeq_cntrl <= 0;
                    blt_cntrl <= 0;
                    alu_cntrl <= 6'b011011; // BNE
                end
                3'b010: begin
		    beq_cntrl <= 0;
                    bneq_cntrl <= 0;
                    bgeq_cntrl <= 0;
                    blt_cntrl <= 0;
                    alu_cntrl <= 6'b011100; // BLT
                end
                3'b100: begin
                    beq_cntrl <= 0;
                    bneq_cntrl <= 0;
                    bgeq_cntrl <= 0;
                    blt_cntrl <= 1;
                    alu_cntrl <= 6'b011101; // BLTI
                end
                3'b101: begin
                    bgeq_cntrl = 1;
                    blt_cntrl = 0;
                    beq_cntrl = 0;
                    bneq_cntrl = 0;
                    alu_cntrl <= 6'b011101; // BGEQ     
                end
                3'b110 :alu_cntrl = 6'b011110; // BGEU
            endcase
        end
        7'b0110111: begin // LUI instruction
            mem_to_reg <= 0;
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
	    bgeq_cntrl <= 0;
            blt_cntrl <= 0;
            jump <= 0;
            lui_cntrl <= 1; // LUI
            lb <= 0;
            sw <= 0;
            alu_cntrl <= 6'b010010; // LUI
        end
        7'b1101111: begin // J-type instructions
            mem_to_reg <= 0;
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
            bgeq_cntrl <= 0;
            blt_cntrl <= 0;
            jump <= 1; // Jump
            lui_cntrl <= 0;
            lb <= 0;
            sw <= 0;
            alu_cntrl <= 6'b100000; // JAL
        end
        7'b0100101: begin //TIMER Instructions
            mem_to_reg <= 0;
            beq_cntrl <= 0;
            bneq_cntrl <= 0;
	    bgeq_cntrl<=0;
            blt_cntrl <= 0;
            jump <= 0;
            lui_cntrl <= 0;
            lb <= 0;
            sw <= 0;
            case(funct3)
                3'b000: begin 
			timer_en <= 1; // TIM_ENABLE
			alu_cntrl <= 6'b111111;
			end
                3'b001:alu_cntrl <= 6'b100001; // TIM_PSC_I
                3'b010:alu_cntrl <= 6'b100010;// TIM_ARR_I
                3'b111: begin 
			timer_en <= 0; // TIM_DISABLE
			alu_cntrl <= 6'b111111;
			end 
                3'b100:alu_cntrl <= 6'b100011; // TIM_PSC_REG
                3'b101: alu_cntrl <= 6'b100100; // TIM_ARR_REG
			
            endcase
        end
        default: begin
            alu_cntrl <= 6'b111111; 
        end
    endcase
end
end

endmodule


