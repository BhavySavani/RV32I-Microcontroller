module instructionfetch(
    input logic clk,
    input logic reset,
    input logic [31:0] imm_addr,
    input logic [31:0] imm_addr_jump,
    input logic beq,
    input logic bneq,
    input logic bge,
    input logic blt,
    input logic jump,
    output logic [31:0] pc,
    output logic [31:0] current_pc,
    input logic stall
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 32'h00000000; // Reset PC to 0
end
    else if (!stall) begin
	    pc<=pc;
	end
     else begin
        if (jump) begin
            pc <= imm_addr_jump; // Jump to the specified address
        end else if (beq || bneq || bge || blt) begin
            pc <= pc+imm_addr;
        end else  begin
            pc <= pc + 4; 
        end
	
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_pc <= 32'h00000000; 
    end else if(!reset && !jump)begin
        current_pc <= pc+4; 
    end else begin
        current_pc <= current_pc; 
    end
end 

endmodule