module regfile(
    input logic clk,
    input logic reset,
    input logic [4:0] read_reg_num1,
    input logic [4:0] read_reg_num2,
    input logic [4:0] write_reg_num,
    input logic [31:0] write_data_dm,
    input logic reg_write_enable,
    input logic lb,
    input logic sw,
    input logic lui_cntrl,
    input logic [31:0] imm_val_lui,
    input logic [31:0] return_address,
    input logic jump,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2,
    output logic [31:0] read_data_addr_dm,
    output reg [4:0] read_data_lui,
    output logic [31:0] data_out_dm
);

reg [31:0] regfile [31:0]; //memory array of 32 registers, each 32 bits wide

wire [31:0] write_reg_dm;
assign read_data_addr_dm =write_reg_num;
assign write_reg_dm = write_reg_num;
integer i;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1)
            regfile[i] <= i; // Reset all registers to 0
            data_out_dm <= 32'b0; // Reset data output to 0
    end 
    else 
    begin   
        if(lb) begin
            regfile[write_reg_num1] <= write_data_dm; // Load byte operation
        end
        else if(sw) begin
            data_out_dm <= regfile[read_reg_num1]; // Store word operation
        end
        else if(lui_cntrl) begin
            regfile[write_reg_num1] <= imm_val_lui; // Load upper immediate operation
        end
        else if(jump) begin
            regfile[write_reg_num1] <= return_address; // Store return address on jump
        end
        else if(reg_write_enable && write_reg_dm != 5'b0) begin // Avoid writing to x0 (register 0)
            regfile[write_reg_dm] <= write_data_dm; // Write data to the register file
        end
    end
end
assign read_data1 = (read_reg_num1 != 5'b0) ? regfile[read_reg_num1] : 32'b0; // Read data from register 1
assign read_data2 = (read_reg_num2 != 5'b0) ? regfile[read_reg_num2] : 32'b0; // Read data from register 2

endmodule