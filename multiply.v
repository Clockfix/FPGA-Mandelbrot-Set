////////////////////////////////////////////
//
//    | Sign | Exponent  | Mantissa |  
//    | 1bit |   8bits   |  18bits  |
//
//    2^0 => Exponent = 'd127 = 'h7f
//
//    Mantissa = [ ( 1-2^(-126) ) ; 0.5 ]
//   
////////////////////////////////////////////

module multiply #(
    parameter
    SIGN_WIDTH = 1,
    EXPONENT_WIDTH = 8,
    MANTISSA_WIDTH = 18
)
(   
    input            clk,
    input [ 26 :0]   input_a,
    input [ 26 :0]   input_b,
    output [ 26 :0]  output_q,
    
    output           underflow
);

reg [35 : 0 ] reg_multiply = 0; // for mantissa
reg [8 : 0 ]  reg_summ1 = 0;     // for exponent
reg [8 : 0 ]  reg_summ2 = 0;     // for exponent if reg_multiply smaler then 0.5(decimal)
reg           reg_sign = 0;     // for sign
reg [17 : 0 ] reg_mantissa1 = 0;  
reg [17 : 0 ] reg_mantissa2 = 0;    //  if reg_multiply smaler then 0.5(decimal)
reg [8 : 0 ]  reg_summ3 = 0;        // use in comarison and testbench

always@(posedge clk) begin
    if (input_a[17:0] == 0 || input_b[17:0] == 0) begin
        reg_multiply <= 0;
        reg_summ1 <= 0 ;
        reg_summ2 <= 0 ;
        reg_sign <= 0;
        end
    else begin
        reg_multiply <= input_a[17:0] * input_b[17:0];
        reg_summ1 <= input_a[25:18] + input_b[25:18] - 8'h7F ;
        reg_summ2 <= input_a[25:18] + input_b[25:18] - 8'h80 ;
        reg_sign <= input_a[26] ^ input_b[26];
        end
end

always@* begin
    reg_mantissa1 <= reg_multiply >> 18 ; 
    reg_mantissa2 <= reg_multiply >> 17 ;           //  if reg_multiply smaler then 0.5(decimal)
    reg_summ3 <= input_a[25:18] + input_b[25:18];   // use in comarison and testbench
end

assign underflow =  reg_summ3
                    //(input_a[25:18] + input_b[25:18]) 
                    < 8'h7F     
                        ? 1'b1 : 1'b0
                    ;


assign output_q  = reg_multiply[35]  ? 
                        { reg_sign , reg_summ1[7:0] , reg_mantissa1[17:0] } 
                        :
                        { reg_sign , reg_summ2[7:0] , reg_mantissa2[17:0] }
                    ;

endmodule