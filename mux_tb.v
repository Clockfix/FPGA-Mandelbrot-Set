`timescale 10 ns / 1ns

`include "mux.v"


module mux_tb#( parameter 
    SELECT_WIDTH = 4,
    DATA_WIDTH = 12
) ();

reg [DATA_WIDTH-1:0] w_data_rd = 10;
reg [DATA_WIDTH-1:0] w_data_rd0 = 14;
reg [DATA_WIDTH-1:0] w_data_rd1 = 4;
reg [DATA_WIDTH-1:0] w_data_rd2 = 23;
reg [DATA_WIDTH-1:0] w_data_rd3 = 5;
reg [DATA_WIDTH-1:0] w_data_rd4 = 6;
reg [DATA_WIDTH-1:0] w_data_rd5 = 8;
reg [DATA_WIDTH-1:0] w_data_rd6 = 12;
reg [DATA_WIDTH-1:0] w_data_rd7 = 23;
reg [DATA_WIDTH-1:0] w_data_rd8 = 23;
reg [DATA_WIDTH-1:0] w_data_rd9 = 1;
reg [DATA_WIDTH-1:0] w_data_rd10 = 2;
reg [DATA_WIDTH-1:0] w_data_rd11 = 3;
reg [DATA_WIDTH-1:0] w_data_rd12 = 22;
reg [DATA_WIDTH-1:0] w_data_rd13 = 33;
reg [DATA_WIDTH-1:0] w_data_rd14 = 44;
reg [SELECT_WIDTH-1:0] w_vga_line_mux=0;

// 50% duty cycle clock
//always #0.5 clk <= ~clk; 

initial begin
// starting  
// 

#1 w_vga_line_mux<=1;
#1 w_vga_line_mux<=2;
#1 w_vga_line_mux<=3;
#1 w_vga_line_mux<=4;
#1 w_vga_line_mux<=5;
#1 w_vga_line_mux<=6;
#1 w_vga_line_mux<=7;
#1 w_vga_line_mux<=8;
#1 w_vga_line_mux<=9;
#1 w_vga_line_mux<=10;



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

mux #(
    .DATA_WIDTH(DATA_WIDTH), 
    .SELECT_WIDTH(SELECT_WIDTH)) 
UnitUnderTest(
    .select(w_vga_line_mux),
    .d0(w_data_rd0),
    .d1(w_data_rd1),
    .d2(w_data_rd2),
    .d3(w_data_rd3),
    .d4(w_data_rd4),
    .d5(w_data_rd5),
    .d6(w_data_rd6),
    .d7(w_data_rd7),
    .d8(w_data_rd8),
    .d9(w_data_rd9),
    .d10(w_data_rd10),
    .d11(w_data_rd11),
    .d12(w_data_rd12),
    .d13(w_data_rd13),
    .d14(w_data_rd14),
    .o_q());

endmodule