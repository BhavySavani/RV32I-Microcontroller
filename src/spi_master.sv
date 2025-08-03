module spi_master(
    input miso,
    output sclk,
    output mosi,
    output cs,
    input clock_in,
    input rs
);

reg [7:0] data=8'b10101001;
reg [7:0] received_data;
reg [2:0] state_mosi;
reg [2:0] state_miso;
localparam MOSI_IDLE_STATE=0;
localparam MISO_IDLE_STATE=7;
localparam MOSI_START_STATE=1;
localparam WRITE_STATE=2;
localparam READ_STATE=3;
localparam MOSI_STOP_STATE=4;
localparam MISO_START_STATE=5;
localparam MISO_STOP_STATE=6;
reg [3:0]mosi_counter;
reg [3:0] miso_counter;
reg spi_clk;
reg cs_out;
reg mosi_out;
assign sclk=spi_clk;
assign cs = cs_out;
assign mosi=mosi_out;
initial begin
    state_mosi=MOSI_IDLE_STATE;
    state_miso=MISO_IDLE_STATE;
    spi_clk=1;
    mosi_out=1;
    cs_out=1;
end

always @ (posedge clock_in) begin
    if (rs==1) begin
        spi_clk=0;
    end
    else begin
        spi_clk=~spi_clk;
    end
end


always @ (posedge spi_clk) begin
    case(state_mosi)
        MOSI_IDLE_STATE:
            begin
                if (cs==0)begin
                    state_mosi=MOSI_START_STATE;
                end
            end
        MOSI_START_STATE:begin
            mosi_out=0;
            state_mosi=WRITE_STATE;
            mosi_counter=7;
        end
        WRITE_STATE:begin
            if(mosi_counter==0)begin
                state_mosi=MOSI_STOP_STATE;
            end
            mosi_out=data[mosi_counter];
            mosi_counter=mosi_counter-1;
        end
        MOSI_STOP_STATE:
        begin
            mosi_out=1;
            state_mosi=MOSI_IDLE_STATE;
        end
    endcase
end
always @(negedge spi_clk)begin
    case(state_miso)
            MISO_IDLE_STATE:
                begin
                if (cs==0)begin
                    state_miso=MISO_START_STATE;
                end
            end
            MISO_START_STATE:begin
                if(miso==0)begin
                    state_miso=READ_STATE;
                    miso_counter=7;
                end
            end
            READ_STATE:begin
                received_data[miso_counter]=miso;
                miso_counter=miso_counter-1;
                if(miso_counter==0)begin
                    state_miso=MISO_STOP_STATE;
                end
            end
            MISO_STOP_STATE:begin
                state_miso=MISO_IDLE_STATE;
            end
       
    endcase
end




endmodule