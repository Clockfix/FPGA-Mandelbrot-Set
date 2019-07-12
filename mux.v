module mux #( parameter
    DATA_WIDTH = 12, 
    SELECT_WIDTH = 4
)(
    input [SELECT_WIDTH - 1 :0]     select,
    input [DATA_WIDTH - 1 :0]       d0,
    input [DATA_WIDTH - 1 :0]       d1,
    input [DATA_WIDTH - 1 :0]       d2,
    input [DATA_WIDTH - 1 :0]       d3,
    input [DATA_WIDTH - 1 :0]       d4,
    input [DATA_WIDTH - 1 :0]       d5,
    input [DATA_WIDTH - 1 :0]       d6,
    input [DATA_WIDTH - 1 :0]       d7,
    input [DATA_WIDTH - 1 :0]       d8,
    input [DATA_WIDTH - 1 :0]       d9,
    input [DATA_WIDTH - 1 :0]       d10,
    input [DATA_WIDTH - 1 :0]       d11,
    input [DATA_WIDTH - 1 :0]       d12,
    input [DATA_WIDTH - 1 :0]       d13,
    input [DATA_WIDTH - 1 :0]       d14,
    output[DATA_WIDTH - 1 :0]      o_q  
);

reg [DATA_WIDTH - 1 :0]      q ;

always @*
begin
   case( select )
       'd0 : q <= d0;
       'd1 : q <= d1;
       'd2 : q <= d2;
       'd3 : q <= d3;
       'd4 : q <= d4;
       'd5 : q <= d5;
       'd6 : q <= d6;
       'd7 : q <= d7;
       'd8 : q <= d8;
       'd9 : q <= d9;
       'd10 : q <= d10;
       'd11 : q <= d11;
       'd12 : q <= d12;
       'd13 : q <= d13;
       'd14 : q <= d14;
       default : q <= 12'd0;
   endcase
end

assign o_q = q;

endmodule