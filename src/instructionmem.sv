module instructionmem(
    input logic clk,
    input logic [31:0] pc,
    input logic reset,
    output logic [31:0] instruction
);
    
    logic [7:0] instruction_memory [0:255];
    // Initialize instruction memory with some example instructions
    initial begin
        instruction_memory[0] = 8'h00; 
        instruction_memory[1] = 8'h62; 
        instruction_memory[2] = 8'h83; 
        instruction_memory[3] = 8'hB3;
        instruction_memory[4] = 8'h00; 
        instruction_memory[5] = 8'h83; 
        instruction_memory[6] = 8'h8C; 
        instruction_memory[7] = 8'h63;
        instruction_memory[24] = 8'h00; 
        instruction_memory[25] = 8'h02; 
        instruction_memory[26] = 8'h10; 
        instruction_memory[27] = 8'h25;
	    instruction_memory[28] = 8'h00; 
        instruction_memory[29] = 8'hFF; 
        instruction_memory[30] = 8'h20; 
        instruction_memory[31] = 8'h25;
	    instruction_memory[32] = 8'h00; 
        instruction_memory[33] = 8'h00; 
        instruction_memory[34] = 8'h00; 
        instruction_memory[35] = 8'h25;

    end

    assign instruction = (reset) 
        ? 32'h00000000 
        : {instruction_memory[pc], instruction_memory[pc+1], instruction_memory[pc+2], instruction_memory[pc+3]};
	
    
    
endmodule