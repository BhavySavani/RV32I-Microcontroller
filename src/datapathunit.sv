module datapathunit(
    input logic clk,
    input logic reset,
    input logic [4:0] read_reg_num1,
    input logic [4:0] read_reg_num2,
    input logic [4:0] write_reg_num,
    input logic [5:0]   alu_cntrl,
    input  jump,beq_cntrl,zero_flag,reg_dst,mem_to_reg,bneq_cntrl,
    input logic [31:0] imm_val_store,
    input logic [31:0] imm_val,
    input logic [3:0] shamt,
    input lb,
    input sw,
    input bgeq_cntrl,blt_cntrl,lui_cntrl,
    input [31:0] imm_val_lui,
    input [31:0] imm_val_jump,
    input [31:0] return_address,
    input logic timer_en,timer_reg_en,
    output [4:0] read_data_addr_dm,
    output beq,bneq,bge,blt,
    output logic [15:0] TIM_PSC,
    output logic [15:0] TIM_ARR,
    output logic [31:0] write_data_alu,
    input logic [11:0] offset
); 
reg [31:0] pc_current;
reg [31:0] pc_next,pc_2;
wire [31:0] instr;
wire [31:0] ext_imm;
wire [31:0] read_reg_data_2;
wire [31:0] read_reg_data_1;
wire [31:0] reg_write_dest;
wire [31:0] reg_read_data_2;// wire for getting data from register file
wire [31:0] pc_j,pc_beq,pc_bneq;
wire bneq_control;
wire [31:0] pc_2beq;
wire [31:0] pc_2bneq;
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [4:0] read_data_addr_dm_2;
wire [31:0] write_data_dm;
wire [4:0] rd_addr;
wire [31:0] data_out;
wire [31:0]  data_out_2_dm;
wire [31:0] read_data_from_dm;
wire [4:0] write_addr;

regfile rfu (clk,reset,read_reg_num1,read_reg_num2,write_reg_num,data_out,lb,lui_control,imm_val_lui,return_address,jump,read_data1,read_data2,read_data_addr_dm_2);
alu alu_unit(read_data1,read_data2,alu_cntrl,imm_val,shamt,write_data_alu);
data_memory dmu(clk,reset,write_addr,data_out_2_dm,sw,imm_val[4:0],read_data_from_dm);  
initial begin 
    pc_current<=32'd0;
end

always@(posedge clk)
    begin
            pc_current <= pc_next;
    end
    assign write_addr = (sw == 1'b1) ? read_data1 + offset : 5'bz;
    assign data_out_2_dm = (sw == 1'b1) ? write_data_alu : 32'bz;
    assign pc2 = pc_current + 4;
    assign data_out = (mem_to_reg == 1'b1) ? read_data_from_dm : write_data_alu;
    assign jump_shift = {instr[11:0],1'b0};
    assign reg_read_addr_1 = instr[13:10];
    assign reg_read_addr_2 = instr[9 :6];
    assign read_data_addr_dm = read_data_addr_dm_2;
    assign beq = (write_data_alu == 1 && beq_cntrl == 1) ? 1 : 0;
    assign bneq = (write_data_alu == 1 && bneq_cntrl == 1) ? 1 : 0;
    assign bge = (write_data_alu == 1 && bgeq_cntrl == 1) ? 1 : 0 ;
    assign blt = (write_data_alu == 1 && blt_cntrl == 1) ? 1 : 0;
    assign ext_imm = {{10{instr[31]}},instr[31:21]};
    assign pc_beq = pc2 + {ext_imm[31:21],1'b0};
    assign pc_bneq = pc2 + {ext_imm[31:21],1'b0};
    assign reg_write_dest = (reg_dst == 1'b1) ? instr[24 : 20] : instr[19 : 15];
    assign read_reg_num1 = (timer_reg_en == 1'b1 && timer_en == 1'b1) ? instr[19:15]:5'bzzzzz;
    assign TIM_PSC = (timer_reg_en == 1'b1 && timer_en == 1'b1 && write_data_alu==8'b00000001) ? read_data1[15:0] : 16'bz; // TIM_PSC
    assign TIM_ARR = (timer_reg_en == 1'b1 && timer_en == 1'b1 && write_data_alu==8'b00000010) ? read_data1[15:0] : 16'bz; // TIM_ARR
endmodule


