// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "clock_divider_param.v"
`include "clock_enable_param.v"
`include "blockram.v"
`include "pattern_gen.v"
`include "vga_module.v"
`include "horizontal_counter.v"
`include "vertical_counter.v"
// `include "UART_Loopback_module.v"
// `include "UART_TX.v"
// `include "UART_RX.v"
// `include "7segment.v"
// `include "com_to_mem_FSM_hex.v" 
// `include "com_to_mem_module.v"
// `include "debounce_switch.v"
`include "mux.v"


//top module
`include "top.v"

module top_tb#( parameter
    WAIT = 1,
    WAIT_WIDTH = 2//,
    // SPEED = 2,
    //  //memory parameters
    // ADDR_WIDTH = 17, //19, // 
    // DATA_WIDTH = 12, 
    // DEPTH =  307_200//76_800, // 
)();

reg clk = 1'b0;
// reg pclk = 1'b0;
// reg hs = 1'b0;
// reg vs = 1'b0;

// 50% duty cycle clock
always #0.5 clk <= ~clk;
// always #2 pclk <= ~pclk;
// always #100 hs <= 1;
// always #102 hs <= 0;
// always #200 vs <= 1;
// always #202 vs <= 0;

// reg RsRx;
// wire RsTx;

top #(
    // .SPEED(SPEED),
    // .ADDR_WIDTH(ADDR_WIDTH),
    // .DATA_WIDTH(DATA_WIDTH),
    // .DEPTH(DEPTH)
)Test_Unit(
    .clk(clk)//, 
    // .RsRx(RsRx),
    // .RsTx(RsTx),
    // .sw(3'b101),
    // .ov7670_cam1_pclk(pclk),
    // .ov7670_cam2_pclk(pclk),
    // .ov7670_cam1_vs(vs),
    // .ov7670_cam1_hs(hs),
    // .ov7670_cam2_vs(vs),
    // .ov7670_cam2_hs(hs),
    // .im_p(9'b00_01_01_000)  
);

// initial begin

// end


initial begin

    $display("*");
    #030_000; 
    $display("*");

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

endmodule