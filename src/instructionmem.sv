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
        instruction_memory[1] = 8'h02; 
        instruction_memory[2] = 8'h10; 
        instruction_memory[3] = 8'h25;
	instruction_memory[4] = 8'h00; 
        instruction_memory[5] = 8'hFF; 
        instruction_memory[6] = 8'h20; 
        instruction_memory[7] = 8'h25;
	instruction_memory[8] = 8'h00; 
        instruction_memory[9] = 8'h00; 
        instruction_memory[10] = 8'h00; 
        instruction_memory[11] = 8'h25;

    end

    assign instruction = (reset) 
        ? 32'h00000000 
        : {instruction_memory[pc], instruction_memory[pc+1], instruction_memory[pc+2], instruction_memory[pc+3]};
	
    
    
endmodule