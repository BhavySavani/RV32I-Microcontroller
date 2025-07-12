module instructionmem(
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    output logic [31:0] instruction
);
    
    logic [7:0] instruction_memory [0:255];
    // Initialize instruction memory with some example instructions
    initial begin
        instruction_memory[0] = 8'b00000000; 
        instruction_memory[1] = 8'b00010000; 
        instruction_memory[2] =8'b00000000; 
        instruction_memory[3] = 8'b00010011; 
        
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction <= 32'h00000000; // Reset instruction to NOP
        end else begin
            instruction <= {instruction_memory[pc+3], instruction_memory[pc+2], instruction_memory[pc+1], instruction_memory[pc]};
    end
    end0
    
endmodule0000