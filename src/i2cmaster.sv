module i2c_master(
    inout sda,
    output scl,
    
    input logic clk,
    input logic rst,
    input logic[6:0] addr,
    input logic[7:0] data,
    input logic en,
    input logic rw,
    
    output logic [7:0] data_out,
    output logic ready,
    output logic read_data
    );
    
    assign read_data = sda;
    
    localparam IDLE_STATE = 0;
    localparam START_STATE = 1;
    localparam ADDR_STATE = 2;
    localparam READ_ACK = 3;
    localparam WRITE_DATA = 4;
    localparam WRITE_ACK = 5;
    localparam READ_DATA = 6;
    localparam READ_ACK2 = 7;
    localparam STOP_STATE = 8;
    
    reg[7:0] state;
    reg[7:0] save_data;
    reg[7:0] save_addr;
    reg[7:0] counter;
    reg write_enable;
    reg sda_out;
    reg i2c_scl_enable = 0;
    reg i2c_clk =1;
    reg [6:0] clk_count;
    assign ready = ((rst == 0) && (state == IDLE_STATE)) ? 1 : 0;
    assign scl = (i2c_scl_enable == 0) ? 1 : i2c_clk;
    assign sda = (write_enable == 1) ? sda_out : 'bz;
  initial begin
  state = IDLE_STATE;
  clk_count=0;
 end
    
    always @(posedge clk) begin
        if (rst) begin 
            i2c_clk = 1;
        end
        
        else begin
            if(clk_count==127)
                begin
                i2c_clk = ~i2c_clk;
                clk_count=0;
                end
            else clk_count=clk_count+1;
                
        end
    end
    
    always @(negedge i2c_clk, posedge rst) begin
  if(rst == 1) begin
   i2c_scl_enable <= 0;
  end else begin
   if ((state == IDLE_STATE) || (state == START_STATE) || (state == STOP_STATE)) begin
    i2c_scl_enable <= 0;
   end else begin
    i2c_scl_enable <= 1;
   end
  end
	
 end

    always @(posedge i2c_clk) begin
        if (rst) begin
            counter = 0;
        end
        
        else begin
            case(state) 
                IDLE_STATE : begin
                    if (en) begin
                        state = START_STATE;
                        save_addr = {addr,rw};
                        save_data = data;
                    end
                    else state = IDLE_STATE;
                end
                
                START_STATE : begin
                    counter = 7;
                    state = ADDR_STATE;
                end
                
                ADDR_STATE : begin
                    if (counter == 0) begin
                        state = READ_ACK;
                    end
                    else begin
                        counter = counter -1;
                    end
                end
                
                READ_ACK : begin
                
                        counter = 7;
                        if (save_addr[0] == 0) begin
                            state = WRITE_DATA;
                        end
                        else state = READ_DATA;
                    
                end
                
                WRITE_DATA : begin
                    if (counter == 0) begin
                        state = READ_ACK2;
                    end
                    
                    else begin
                        counter = counter - 1;
                    end
                end
                
                WRITE_ACK : begin
                    state = STOP_STATE;
                end
                
                READ_DATA : begin
                    data_out[counter] = sda;
                    if (counter == 0 )begin
                    
                            state = READ_ACK2;
                    
                        counter=7;
                    end
                    else counter = counter -1;
                end
                
                READ_ACK2 : begin
                    if ((sda==0) && (en == 1)) begin
                        state = READ_DATA;
                    end
                    else state = STOP_STATE;
                end
                
                STOP_STATE : begin
                    state = IDLE_STATE;
                end
            endcase
        end
    end
    
always @(negedge i2c_clk) begin
    case(state)
        
        START_STATE : begin
            write_enable = 1;
            sda_out = 0;
        end
        
        ADDR_STATE : begin  
            sda_out = save_addr[counter];
        end
        
        READ_ACK : begin
            write_enable = 0;
        end
        
        WRITE_DATA : begin
            write_enable = 1;
            sda_out = save_data[counter];
        end
        
        READ_ACK2 : begin
            write_enable = 0;
        end
        
        WRITE_ACK : begin
            write_enable = 1;
            sda_out = 0;
        end
        
        STOP_STATE : begin
            write_enable = 1;
            sda_out = 1;
        end
        
        READ_DATA : begin
            write_enable = 0;
        end
    endcase
    end
    
endmodule