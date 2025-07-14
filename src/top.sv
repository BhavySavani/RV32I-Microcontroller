
module top(
                    input clk,
                    input reset
    );
    
    wire [31:0] imm_val_top;        //extracted immediate value (sign extended)
    wire [31:0] pc;                 //programme counter
    wire [31:0] instruction_out;    //output of instruction memory
    wire  [5:0] alu_control;        // control signal for determining the type of the alu operation
    wire  mem_to_reg;               // control signal for enabling memory to register file operation           
    wire  bneq_control;             // control signal for enabling bneq instruction                  
    wire  beq_control;              // control signal for branch equal to instruction     
    wire  jump;                     // control signal for enabling jump instruction
    wire [31:0] read_data_addr_dm;  // address for reading the data from data memory
    wire [31:0] imm_val;            // extracted immediate value from the instruction (sign extended)
    wire lb;                        // signal for enabling load operation
    wire sw;                        // signal for enabling store opeation
    wire [31:0] imm_val_branch_top; // extracted immediate value for branch instruction (sign extended)
    wire beq,bneq;                  // control signals for performiing branch equal to and not equal to operations
    wire bgeq_control;              // control signals for enabling branch greater than or equal to instruction
    wire blt_control;               // control signal for enabling branch less than instruction
    wire bge;                       // control signal for enabling branch greater than instruciton       
    wire blt;                       // control signal for enabling branch less than instruction
    wire lui_control;               // control signal for enabling load upper immediate operation
    wire [31:0] imm_val_lui;        // extracted immediate value for load upper immediate instruction (sign extended)
    wire [31:0] imm_val_jump;       // extracted immediate value for jump instruction (sign extended)
    wire [31:0] current_pc;         // register for storing return programme counter
	wire [31:0]immediate_value_store_temp;
	wire [31:0]immediate_value_store;
	wire [4:0] base_addr;
    
    
    
    instructionfetch ifu(clk,
                               reset,
                               imm_val_branch_top,
                               imm_val_jump,
                               beq,
                               bneq,
                               bge,
                               blt,
                               jump,
                               pc,
                               current_pc);

   
    instructionmem imu(clk,
                           pc,
                           reset,
                           instruction_out);
                           
    
    
    cu cu(reset,
                    instruction_out[31:25],
                    instruction_out[14:12],
                    instruction_out[6:0],
                    alu_control,
                    lb,
                    mem_to_reg,
                    bneq_control,
                    beq_control,
                    bgeq_control,
                    blt_control,
                    jump,
                    sw,
                    lui_control,
                    );


    datapathunit dpu(clk,reset,
                  instruction_out[19:15],
                  instruction_out[24 : 20],
                  instruction_out[11 : 7],
                  alu_control,
                  jump,
                  beq_control,
                  zero_flag,
                  reg_dst,
                  mem_to_reg,
                  bneq_control,
                  immediate_value_store,
                  instruction_out[24:20],
                  lb,
                  sw,
                  bgeq_control,
                  blt_control,
                  lui_control,
                  imm_val_lui,
                  imm_val_jump,
                  current_pc,
                  timer_en,
                  timer_reg_en,
                  read_data_addr_dm,
                  beq,
                  bneq,
                  bge,
                  blt,
                  TIM_PSC_REG,
                  TIM_ARR_REG,
                  );

    TIM timer_unit(clk,
                    timer_en,
                    TIM_PSC, // TIM_PSC
                    TIM_ARR, // TIM_ARR
                    TIM_CNT, // 16-bit timer value
                    timer_interrupt // Timer done signal
    );
    assign imm_val_top = {{20{instruction_out[31]}},instruction_out[31:21]};
    assign imm_val_branch_top = {{20{instruction_out[31]}},instruction_out[30:25],instruction_out[11:8],instruction_out[7]};
    assign imm_val_lui = {10'b0,instruction_out[31:12]};
    assign imm_val_jump = {{10{instruction_out[31]}},instruction_out[31:12]};
    assign imm_val = imm_val_top;
	
    assign immediate_value_store_temp = {{20{instruction_out[31]}},instruction_out[31:12]};
    
    assign base_addr = instruction_out[19:15];
	
    assign immediate_value_store = immediate_value_store_temp + base_addr;

	assign TIM_PSC =(timer_reg_en == 1'b0 && timer_en == 1'b1 && write_data_alu==8'b00000001) ? instruction_out[31:16] : 16'bz; // TIM_PSC
	assign TIM_ARR =(timer_reg_en == 1'b0 && timer_en == 1'b1 && write_data_alu==8'b00000010) ? instruction_out[31:16] : 16'bz; // TIM_ARR

    endmodule