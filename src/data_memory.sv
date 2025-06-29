module data_memory (
    input logic clk,
    input logic rst, 
    input logic [4:0]  write_addr,    
    input logic [31:0] write_data,    
    input logic        we,            

    input logic [4:0]  read_addr,     
    output logic [31:0] read_data      
);

    reg [31:0] mem [0:31];

   
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // On reset, clear memory 
            for (int i = 0; i < 32; i = i + 1) begin
                mem[i] <= 32'h0;
            end
        end else if (we) begin // If write enable is high
            mem[write_addr] <= write_data;
        end
    end

    always_comb begin
        read_data = mem[read_addr];
    end

    
    initial begin
        for (int i = 0; i < 32; i = i + 1) begin
            mem[i] = 32'h0; // Initialize all to 0
        end
    end

endmodule