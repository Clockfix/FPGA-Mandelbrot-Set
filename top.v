//      TOP module 
//       
//      

module top #( parameter
    //pattern generator paremater
    SPEED = 300,
    //enable signal parameters
    WAIT = 1,
    WAIT_WIDTH = 2,
    //memory parameters
    ADDR_WIDTH = 13, // 
    DATA_WIDTH = 12, 
    DEPTH =  5_120, // ( 320 * 16 ) 
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
//    output  [11:0]  led,
    //VGA  inputs outputs
    output [3:0]    vgaRed,
    output [3:0]    vgaBlue,
    output [3:0]    vgaGreen,
    output          Hsync,
    output          Vsync//,
    // input [2:0]     sw,
    // //UART 
    // input           RsRx,         // UART RX Data
    // output          RsTx,        // UART TX Data
    // // 7 segment
    // output  [6:0]   seg, 
    // output  [3:0]   an  
    );

//------internal wires and registers--------
wire w_enable;
 
wire w_write;

wire [ADDR_WIDTH-1:0] w_addr_wr;
wire [DATA_WIDTH-1:0] w_data_wr;

wire [ADDR_WIDTH-1:0] w_com_addr_wr;
wire [DATA_WIDTH-1:0] w_com_data_wr;
wire w_com_write;
wire [ADDR_WIDTH-1:0] w_com_addr_rd;

wire [3:0] w_vga_line_mux;

wire [ADDR_WIDTH-1:0] w_addr_rd;

wire [DATA_WIDTH-1:0] w_data_rd;
wire [DATA_WIDTH-1:0] w_data_rd0;
wire [DATA_WIDTH-1:0] w_data_rd1;
wire [DATA_WIDTH-1:0] w_data_rd2;
wire [DATA_WIDTH-1:0] w_data_rd3;
wire [DATA_WIDTH-1:0] w_data_rd4;
wire [DATA_WIDTH-1:0] w_data_rd5;
wire [DATA_WIDTH-1:0] w_data_rd6;
wire [DATA_WIDTH-1:0] w_data_rd7;
wire [DATA_WIDTH-1:0] w_data_rd8;
wire [DATA_WIDTH-1:0] w_data_rd9;
wire [DATA_WIDTH-1:0] w_data_rd10;
wire [DATA_WIDTH-1:0] w_data_rd11;
wire [DATA_WIDTH-1:0] w_data_rd12;
wire [DATA_WIDTH-1:0] w_data_rd13;
wire [DATA_WIDTH-1:0] w_data_rd14;

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
    .i_enable(w_enable),
    .o_addr(w_addr_wr),
    .o_data(w_data_wr),
    .o_write(w_write)
);


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
    .o_line_mux(w_vga_line_mux),
    .o_addr_rd(w_addr_rd),
    .i_data_rd(w_data_rd)
   );

// com_to_mem #( 
//     .WAIT(WAIT),
//     .WAIT_WIDTH(WAIT_WIDTH),
//     .ADDR_WIDTH(ADDR_WIDTH),
//     .DATA_WIDTH(DATA_WIDTH), 
//     .DEPTH(DEPTH)
// ) com_to_mem1 (
//     .clk(clk),
//     .sw(sw[0]),
//     //.i_data_rd(w_doa_bram),
//     .i_enable(w_enable),
//     .o_addr_wr(w_com_addr_wr),
//     .o_addr_rd(w_com_addr_rd),
//     .o_data_wr(w_com_data_wr),
//     .o_write(w_com_write),
//     .RsRx(RsRx),         // UART RX Data
//     .RsTx(RsTx),        // UART TX Data
//     .seg(seg), 
//     .an(an),
//     .o_addr_wr_reg(w_addr_com_wr_reg),
//     .o_data_reg(w_data_com_reg),
//     .o_we_reg(w_we_com_reg)
//     );

// debounce_switch debounce_switch_reset(
//     .clk(clk),
//     .i_switch(btnU),
//     .o_switch(w_reset_default)
// );

mux #(
    .DATA_WIDTH(DATA_WIDTH), 
    .SELECT_WIDTH('d4)) 
mux1(
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
    .o_q(w_data_rd));



//-------------- memory modules-------------------------

blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram0(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd0));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram1(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd1));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram2(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd2));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram3(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd3));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram4(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd4));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram5(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd5));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram6(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd6));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram7(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd7));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram8(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd8));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram9(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd9));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram10(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd10));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram11(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd11));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram12(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd12));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram13(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd13));


blockram #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram14(
    // -------------------------PORT A (write)
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_write ),
    .addra( w_addr_wr ),
    .dia( w_data_wr ),
    .doa(   ),

    //---------------------------PORT B (read)
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd14));

endmodule