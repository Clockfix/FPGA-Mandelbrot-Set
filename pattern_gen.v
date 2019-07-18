// This module generates color patherns and rwite them in 
// BlockRAM memory
//
module pattern_gen #( parameter
    LINES = 16,
    COLUMNS = 320,
    DEPTH =  76_800, //307_200, //
    ADDR_WIDTH = 17,
    DATA_WIDTH = 12,
    SPEED = 2,
    SIZE = 2
)(  
    input clk,
    input i_enable,
    output [ADDR_WIDTH-1:0] o_addr,
    output [DATA_WIDTH-1:0] o_data,
    output o_write);

//-------------Internal Constants---------------------------
reg [31:0] speed_counter_reg = 'b0;

// reg [3:0] red_reg = 'b0;
// reg [3:0] blue_reg = 'b0;
// reg [3:0] green_reg = 'b0;

reg [8:0] line_reg = 'b0;
reg [9:0] column_reg = 'b0;

reg write_reg=1'b0;

// always @(posedge clk) begin
//     speed_counter_reg <= speed_counter_reg + 1;
// end


always @(posedge clk) begin
//    speed_counter_reg <= speed_counter_reg + 1;
    
 //   if(speed_counter_reg == SPEED ) begin
      //  if(i_enable) begin
        write_reg <= 1'b1;
        speed_counter_reg <= 0;
        
            if(column_reg < COLUMNS-1) begin 
                column_reg <= column_reg + 1 ;
            end
            else begin
                column_reg <= 0;
                if (line_reg< LINES -1 ) begin
                    line_reg <= line_reg + 1;
                end
                else begin
                    line_reg <= 0;
                end
            end 

       // end
    // end
    // else // if (i_enable) 
    //     write_reg <= 1'b0;
end

// always@* begin
//         if (line_reg < 239 ) begin
//             green_reg <= 4'b1111;
//         end
//         else begin
//             green_reg <= 4'b0000;
//         end

//         if (column_reg > 319 ) begin
//             red_reg <= 4'b1111;
//         end
//         else begin
//             red_reg <= 4'b0000;
//         end
// end


assign o_addr = (line_reg * COLUMNS) + column_reg ;
assign o_data = {line_reg[3:0], line_reg[3:0], line_reg[3:0]};//{green_reg, red_reg , blue_reg};
assign o_write = write_reg;

endmodule