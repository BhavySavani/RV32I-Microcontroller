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
        instruction_memory[2] = 8'h8A; 
        instruction_memory[3] = 8'h63;
	instruction_memory[20] = 8'h12; 
        instruction_memory[21] = 8'h34; 
        instruction_memory[22] = 8'h52; 
        instruction_memory[23] = 8'hB7;

    end

    assign instruction = (reset) 
        ? 32'h00000000 
        : {instruction_memory[pc], instruction_memory[pc+1], instruction_memory[pc+2], instruction_memory[pc+3]};
	
    
    
endmodule