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
// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

`include "multiply.v"

module multiply_tb ();

// 50% duty cycle clock
reg clk = 1'b1;
always #0.5 clk <= ~clk; 

reg [26 : 0 ] reg_input_a = 0; 
reg [26 : 0 ] reg_input_b = 0; 


initial begin

    #100    
    reg_input_a = 27'h5FE0000;
    reg_input_b = 27'h1FE0000;

    #100    
    reg_input_a = 27'h13E8083;
    reg_input_b = 27'h13E8083;

    #100    
    reg_input_a = 27'h0E2194D;
    reg_input_b = 27'h0E2194D;

    #100    
    reg_input_a = 27'h20A0000;
    reg_input_b = 27'h0E2194D;

    #100    
    reg_input_a = 27'h20A0000;
    reg_input_b = 27'h2020000;

    #100    
    reg_input_a = 27'h226A800;
    reg_input_b = 27'h6270C00;
    
    #100    
    reg_input_a = 27'h64E05F8;
    reg_input_b = 27'h1FE0000;

    #100    
    reg_input_a = 27'h64A05F8;

    #100    
    reg_input_b = 27'h64A05F8;


    #1000
    $display(" ");
    $display("Use this command to open timing diagram:");
    $display("gtkwave -f wave.vcd");
    $display("----------------------------------------------");
    $finish();
end

initial 
  begin 
    $display(" ");
    $display("----------------------------------------------");
    $display("          Starting Testbench...");
    $dumpfile("wave.vcd");
    $dumpvars(0);

end

multiply Test_Unit(
    .clk(clk),
    .input_a(reg_input_a),
    .input_b(reg_input_b),
    .output_q(),
    .underflow()      
);


endmodule