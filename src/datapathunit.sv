module datapathunit(
    input logic clk,
    input logic reset,
    input logic [4:0] read_reg_num1,
    input logic [4:0] read_reg_num2,
    input logic [4:0] write_reg_num,
    input logic [5:0]   alu_cntrl,
    input  jump,beq_cntrl,bneq_cntrl,mem_to_reg,reg_dst,zero_flag,bgeq_cntrl,blt_cntrl,lui_cntrl,
    input logic [31:0] imm_val,
    input logic [31:0] shamt,
    input lb,
    input sw,
    input [31:0] imm_val_lui,
    input [31:0] imm_val_jump,
    input [31:0] return_address,
    output [4:0] read_data_addr_dm,
    output beq,bneq,bgeq,blt
); 


endmodule
