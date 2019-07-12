//      TOP module 
//       
//      
// `include "clock_divider_param.v"
// `include "clock_enable_param.v"
// `include "blockram.v"
// `include "pattern_gen.v"
// `include "vga_module.v"
// `include "horizontal_counter.v"
// `include "vertical_counter.v"



module top #( parameter
    //pattern generator paremater
    SPEED = 300,
    //enable signal parameters
    WAIT = 1,
    WAIT_WIDTH = 2,
    //memory parameters
    ADDR_WIDTH = 17, // 19, //
    DATA_WIDTH = 12, 
    DEPTH =  76_800, // 307_200,//
    //VGA parameters
    HSYNC_CLKS = 800,
    HSYNC_DISPLAY = 640,
    HSYNC_PULSE = 96,
    HSYNC_FRONT_PORCH = 16,
    HSYNC_BACK_PORCH = 48,
    VSYNC_LINES = 521,
    VSYNC_DISPLAY = 480,
    VSYNC_PULSE = 2,
    VSYNC_FRONT_PORCH = 10,
    VSYNC_BACK_PORCH = 29
)(
    input           clk,
    output  [11:0]  led,
    output  [1:0]   ledc,   // led camera configuration indicator
    //VGA  inputs outputs
    output [3:0]    vgaRed,
    output [3:0]    vgaBlue,
    output [3:0]    vgaGreen,
    output          Hsync,
    output          Vsync,
    input [2:0]     sw,
    //UART 
    input           RsRx,         // UART RX Data
    output          RsTx,        // UART TX Data
    // 7 segment
    output  [6:0]   seg, 
    output  [3:0]   an  


    );

//------internal wires and registers--------
 wire w_enable;
 wire pixel_clk;

 wire clk50;    

 wire w_write;

 wire [ADDR_WIDTH-1:0] w_addr_wr;
 wire [DATA_WIDTH-1:0] w_data_wr;

 wire [ADDR_WIDTH-1:0] w_com_addr_wr;
 wire [DATA_WIDTH-1:0] w_com_data_wr;
 wire w_com_write;
 wire [ADDR_WIDTH-1:0] w_com_addr_rd;

//  wire [ADDR_WIDTH-1:0] w_addrb;

 wire [ADDR_WIDTH-1:0] w_addr_rd;
 wire [DATA_WIDTH-1:0] w_data_rd;

 

//-----sub modules--------------------------
clock_enable_param #(
    .WAIT(WAIT),
    .WIDTH(WAIT_WIDTH)
  ) clock_enable1 (
    .clk(clk),
    .enable(w_enable)
);

clock_divider #(
    .DIVIDER(2),
    .WIDTH(3)
) clk25mhz_gen (
    .clk(clk),
    .clk_out(pixel_clk)
);



pattern_gen #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .SPEED(SPEED)
) pattern_gen1 (
    .clk(clk),
//    .sw(sw[1]),
    .i_enable(w_enable),
    .o_addr(w_addr_wr),
    .o_data(w_data_wr),
    .o_write(w_write)
);

rams_tdp_rf_rf #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram3(
    // -------------------------PORT A
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_wea_bram ),
    .addra( w_addra_bram ),
    .dia( w_dia_bram ),
    .doa( w_doa_bram ),

    //---------------------------PORT B
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd));


vga_module #(  
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .HSYNC_CLKS(HSYNC_CLKS),
        .HSYNC_DISPLAY(HSYNC_DISPLAY),
        .HSYNC_PULSE(HSYNC_PULSE),
        .HSYNC_FRONT_PORCH(HSYNC_FRONT_PORCH),
        .HSYNC_BACK_PORCH(HSYNC_BACK_PORCH),
        .VSYNC_LINES(VSYNC_LINES) ,
        .VSYNC_DISPLAY(VSYNC_DISPLAY) ,
        .VSYNC_PULSE(VSYNC_PULSE) ,
        .VSYNC_FRONT_PORCH(VSYNC_FRONT_PORCH) ,
        .VSYNC_BACK_PORCH(VSYNC_BACK_PORCH) 
) vga_module1 (
    .clk(pixel_clk),
    .o_vgaRed(vgaRed),
    .o_vgaBlue(vgaBlue),
    .o_vgaGreen(vgaGreen),
    .o_Hsync(Hsync),
    .o_Vsync(Vsync),
    .o_display(),
    .o_addr_rd(w_addr_rd),
    .o_data_rd(w_data_rd)
   );

com_to_mem #( 
    .WAIT(WAIT),
    .WAIT_WIDTH(WAIT_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH), 
    .DEPTH(DEPTH)
) com_to_mem1 (
    .clk(clk),
    .sw(sw[0]),
    //.i_data_rd(w_doa_bram),
    .i_enable(w_enable),
    .o_addr_wr(w_com_addr_wr),
    .o_addr_rd(w_com_addr_rd),
    .o_data_wr(w_com_data_wr),
    .o_write(w_com_write),
    .RsRx(RsRx),         // UART RX Data
    .RsTx(RsTx),        // UART TX Data
    .seg(seg), 
    .an(an),
    .o_addr_wr_reg(w_addr_com_wr_reg),
    .o_data_reg(w_data_com_reg),
    .o_we_reg(w_we_com_reg)
    );



// debounce_switch debounce_switch_reset(
//     .clk(clk),
//     .i_switch(btnU),
//     .o_switch(w_reset_default)
// );




endmodule