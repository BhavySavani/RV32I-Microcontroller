module regfile(
    input logic clk,
 input logic reset,
input logic [4:0] read_reg_num1,
input logic [4:0] read_reg_num2,
input logic [4:0] write_reg_num,
input logic [31:0] write_data_dm,
input logic lb,
input logic lui_cntrl,
input logic [31:0] imm_val_lui,
input logic [31:0] return_address,
input logic jump,
output logic [31:0] read_data1,

output logic [31:0] read_data2,

output logic [31:0] read_data_addr_dm

);



reg [31:0] regfile [31:0];

wire [31:0] write_reg_dm;

assign read_data_addr_dm =write_reg_num;

assign write_reg_dm = write_reg_num;

integer i;

always @(posedge clk or posedge reset) begin

 if (reset) begin
	
for (i = 0; i < 32; i = i + 1) begin
 
 regfile[i] <= 32'h0;

end

 
	//test values for debugging
	regfile[5] <= 32'b00001000000000011000000000000101;
        regfile[6] <= 32'b00001000000000011000000000000101;
	regfile[7] <= 32'b00000000000000000000000000100101;

 end

 else

begin
 regfile[write_reg_num]<=write_data_dm;
 if(lb) begin

 regfile[write_reg_dm] <= write_data_dm; // Load byte operation

 end


 else if(lui_cntrl) begin

 regfile[write_reg_dm] <= imm_val_lui; // Load upper immediate operation

end

 else if(jump) begin

 regfile[write_reg_dm] <= return_address; // Store return address on jump

 end
 
end
end
assign read_data1 = (read_reg_num1 != 5'b0) ? regfile[read_reg_num1] : 32'b0; // Read data from register 1
assign read_data2 = (read_reg_num2 != 5'b0) ? regfile[read_reg_num2] : 32'b0; // Read data from register 2
endmodule
