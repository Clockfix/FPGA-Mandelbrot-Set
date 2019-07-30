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

module summ #(
    parameter
    SIGN_WIDTH = 1,
    EXPONENT_WIDTH = 8,
    MANTISSA_WIDTH = 18,
    SIZE = 2          // size for for registers FSM
)
(   
    input            clk,
    input [ 26 :0]   input_a,
    input [ 26 :0]   input_b,
    input            start,

    output [ 26 :0]  output_q,
    output           done,
    output           overflow,
    output           underflow
);

//-------------Internal Constants---------------------------

localparam  [SIZE-1 :0] IDLE            = 'h0,
                        SHIFT           = 'h1,
                        SUMM            = 'h2,
                        NORM            = 'h3;

reg [SIZE-1:0]          r_state=IDLE, 
                        r_next=IDLE;     

reg [ 18 :0 ]   r_large_mantissa1   = 'b0,
                r_small_mantissa1   = 'b0,
                r_large_mantissa2   = 'b0,
                r_small_mantissa2   = 'b0,
                r_large_mantissa3   = 'b0,
                r_small_mantissa3   = 'b0, 
                r_large_mantissa4   = 'b0,
                r_small_mantissa4   = 'b0;

reg [ 7 :0 ]    r_large_exponent1   = 'b0,
                r_large_exponent2   = 'b0,
                r_large_exponent3   = 'b0,
                r_large_exponent4   = 'b0;

reg             r_large_sign        = 'b0,
                r_small_sign        = 'b0;  

reg [ 7 :0 ]    r_delta_exponent    = 'b0; 

reg             r_done              = 'b0;
reg             r_overflow          = 'b0;
reg             r_underflow         = 'b0;

//---------state register sequential always block-----------

always @(posedge clk ) begin
        r_state <= r_next;
end

//----next state & outputs, combinational always block------

always@(posedge clk) begin
    case(r_state)
        IDLE    :   
            begin
                r_done <= 'b0;
                if (start == 1'b1)
                begin
                    if (input_a[25:18] > input_b[25:18]) 
                    begin
                        r_large_mantissa1 <= input_a[17:0];
                        r_small_mantissa1 <= input_b[17:0];
                        r_large_exponent1 <= input_a[25:18];
                        //r_small_exponent <= input_b[25:18];
                        r_large_sign <= input_a[26];
                        r_small_sign <= input_a[26];
                        r_delta_exponent <= input_a[25:18] - input_b[25:18];
                        r_next <=  SHIFT;
                    end
                    else if (input_a[25:18] < input_b[25:18])
                    begin
                        r_large_mantissa1 <= input_b[17:0];
                        r_small_mantissa1 <= input_a[17:0];
                        r_large_exponent1 <= input_b[25:18];
                        //r_small_exponent <= input_a[25:18];
                        r_large_sign <= input_b[26];
                        r_small_sign <= input_a[26];
                        r_delta_exponent <= input_b[25:18] - input_a[25:18];
                        r_next <=  SHIFT;
                    end
                    else if (input_a[25:18] == input_b[25:18]) 
                    begin
                        r_large_mantissa1 <= input_a[17:0];
                        r_small_mantissa1 <= input_b[17:0];
                        r_large_exponent1 <= input_a[25:18];
                        //r_small_exponent <= input_b[25:18];
                        r_large_sign <= input_a[26];
                        r_small_sign <= input_a[26];
                        r_next <=  SUMM;
                    end
                end
            end
        SHIFT   :   
            begin
                r_next <=  SUMM;
                case(r_delta_exponent)
                    'd1     :   r_small_mantissa2 <= r_small_mantissa1 >> 1;
                    'd2     :   r_small_mantissa2 <= r_small_mantissa1 >> 2;
                    'd3     :   r_small_mantissa2 <= r_small_mantissa1 >> 3;
                    'd4     :   r_small_mantissa2 <= r_small_mantissa1 >> 4;
                    'd5     :   r_small_mantissa2 <= r_small_mantissa1 >> 5;
                    'd6     :   r_small_mantissa2 <= r_small_mantissa1 >> 6;
                    'd7     :   r_small_mantissa2 <= r_small_mantissa1 >> 7;
                    'd8     :   r_small_mantissa2 <= r_small_mantissa1 >> 8;
                    'd9     :   r_small_mantissa2 <= r_small_mantissa1 >> 9;
                    'd10    :   r_small_mantissa2 <= r_small_mantissa1 >> 10;
                    'd11    :   r_small_mantissa2 <= r_small_mantissa1 >> 11;
                    'd12    :   r_small_mantissa2 <= r_small_mantissa1 >> 12;
                    'd13    :   r_small_mantissa2 <= r_small_mantissa1 >> 13;
                    'd14    :   r_small_mantissa2 <= r_small_mantissa1 >> 14;
                    'd15    :   r_small_mantissa2 <= r_small_mantissa1 >> 15;
                    'd16    :   r_small_mantissa2 <= r_small_mantissa1 >> 16;
                    'd17    :   r_small_mantissa2 <= r_small_mantissa1 >> 17;
                    default :   r_small_mantissa2 <= 0;  // if number is to small result is larger number
                endcase        
            end
        SUMM    :   
            begin
                r_next <= NORM;
                case(r_large_sign == r_small_sign)
                    1'b1    :   r_large_mantissa3 <= r_large_mantissa2 + r_small_mantissa2; 
                    1'b0    :   r_large_mantissa3 <= r_large_mantissa2 - r_small_mantissa2;   
                endcase       
            end
        NORM    :   
            begin
                r_next <= IDLE;
                r_done <= 'b1;
                if (r_large_mantissa[18]) 
                begin
                    r_large_mantissa4 <= r_large_mantissa3 >> 1; 
                    if (r_large_exponent < 255)
                        begin r_large_exponent <= r_large_exponent + 1; end 
                    else 
                        begin r_overflow <= 1; end
                end 
                else if (r_large_mantissa[17])  
                begin
                    r_large_mantissa4 <= r_large_mantissa3 << 1;
                    if (r_large_exponent > 0)
                        begin r_large_exponent <= r_large_exponent - 1; end 
                    else 
                        begin r_underflow <= 1; end
                end 
            end
        default : r_next <= IDLE;          // on error
    endcase
end

//-------------------- assignning combionational logic----------------------------

assign done = r_done;
assign output_q = { r_large_sign, r_large_exponent4[7:0], r_large_mantissa4[17:0]  };

endmodule