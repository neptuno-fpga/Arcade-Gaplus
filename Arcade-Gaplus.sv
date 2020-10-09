//============================================================================
//  Arcade: Gaplus
//
//  Original implimentation and port to MiSTer by MiSTer-X 2019
//============================================================================

//============================================================================
//
//  Multicore 2+ Top by Victor Trucco
//
//============================================================================

`default_nettype none


module Gaplus_MC2p
(
 // Clocks
    input wire  clock_50_i,

    // Buttons
    //input wire [4:1]    btn_n_i,

    // SRAM 
//    output wire [19:0]sram_addr_o  = 21'b000000000000000000000,
//    inout wire  [15:0]sram_data_io   = 8'bzzzzzzzz,
//    output wire sram_we_n_o     = 1'b1,
//    output wire sram_oe_n_o     = 1'b1,	 
//	 output wire ram1_ub_n_o     = 1'b1,
//	 output wire ram1_lb_n_o     = 1'b0,	 
	 
        
    // SDRAM (W9825G6KH-6)
//    output [12:0] SDRAM_A,
//    output  [1:0] SDRAM_BA,
//    inout  [15:0] SDRAM_DQ,
//    output        SDRAM_DQMH,
//    output        SDRAM_DQML,
//    output        SDRAM_CKE,
//    output        SDRAM_nCS,
//    output        SDRAM_nWE,
//    output        SDRAM_nRAS,
//    output        SDRAM_nCAS,
//    output        SDRAM_CLK,

    // PS2
    inout wire  ps2_clk_io        = 1'bz,
    inout wire  ps2_data_io       = 1'bz,
    inout wire  ps2_mouse_clk_io  = 1'bz,
    inout wire  ps2_mouse_data_io = 1'bz,

    // SD Card
    output wire sd_cs_n_o         = 1'bZ,
    output wire sd_sclk_o         = 1'bZ,
    output wire sd_mosi_o         = 1'bZ,
    input wire  sd_miso_i,

    // Joysticks
    output wire joy_clock_o       = 1'b1,
    output wire joy_load_o        = 1'b1,
    input  wire joy_data_i,
    output wire joy_p7_o          = 1'b1,

    // Audio
    output      AUDIO_L,
    output      AUDIO_R,
    input wire  ear_i,
    //output wire mic_o             = 1'b0,

    // VGA
    output  [4:0] VGA_R,
    output  [4:0] VGA_G,
    output  [4:0] VGA_B,
    output        VGA_HS,
    output        VGA_VS,

    //STM32
    input wire  stm_tx_i,
    output wire stm_rx_o,
    output wire stm_rst_o           = 1'bz, // '0' to hold the microcontroller reset line, to free the SD card
   
    input         SPI_SCK,
    output        SPI_DO,
    input         SPI_DI,
    input         SPI_SS2,
    //output wire   SPI_nWAIT        = 1'b1, // '0' to hold the microcontroller data streaming

    //inout [31:0] GPIO,

    output LED                    = 1'b1 // '0' is LED on
);


//-- END defaults -------------------------------------------------------

localparam CONF_STR = {
    "P,Gaplus.dat;", 

    "S,DAT,Alternative ROM...;",


    "O78,Screen Rotation,0,90,180,270;",
    "O34,Scanlines,Off,25%,50%,75%;",
    "O5,Blend,Off,On;",
    "O9,Scandoubler,On,Off;",

    "OJK,Difficulty,Standard,1-Easiest,2,3,4,5,6,7-Hardest;", //8->A
    "OBC,Life,3,2,4,5;",
    "ODF,Bonus Life,M0,M1,M2,M3,M4,M5,M6,M7;",
    "OG,Round Advance,Off,On;",
    "OH,Demo Sound,On,Off;",
    //"OJ,Cabinet,Upright,Cocktail;",

    "OI,Service Mode,Off,On;",

    "T0,Reset;",
    "V,v"
};



//---------------------------------------------------------
//-- MC2+ defaults
//---------------------------------------------------------
//assign GPIO = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign stm_rst_o    = 1'bZ;
//assign stm_rx_o = 1'bZ;
assign LED  = ~ioctl_download;

//no SRAM for this core
//assign sram_we_n_o  = 1'b1;
//assign sram_oe_n_o  = 1'b1;

//no SDRAM for this core
//assign SDRAM_nCS = 1'b1;

//all the SD reading goes thru the microcontroller for this core
//assign sd_cs_n_o = 1'bZ;
//assign sd_sclk_o = 1'bZ;
//assign sd_mosi_o = 1'bZ;

wire joy1_up_i, joy1_down_i, joy1_left_i, joy1_right_i, joy1_p6_i, joy1_p9_i;
wire joy2_up_i, joy2_down_i, joy2_left_i, joy2_right_i, joy2_p6_i, joy2_p9_i;

//joystick_serial  joystick_serial 
//(
//    .clk_i           ( clk_sys ),
//    .joy_data_i      ( joy_data_i ),
//    .joy_clk_o       ( joy_clock_o ),
//    .joy_load_o      ( joy_load_o ),
//
//    .joy1_up_o       ( joy1_up_i ),
//    .joy1_down_o     ( joy1_down_i ),
//    .joy1_left_o     ( joy1_left_i ),
//    .joy1_right_o    ( joy1_right_i ),
//    .joy1_fire1_o    ( joy1_p6_i ),
//    .joy1_fire2_o    ( joy1_p9_i ),
//
//    .joy2_up_o       ( joy2_up_i ),
//    .joy2_down_o     ( joy2_down_i ),
//    .joy2_left_o     ( joy2_left_i ),
//    .joy2_right_o    ( joy2_right_i ),
//    .joy2_fire1_o    ( joy2_p6_i ),
//    .joy2_fire2_o    ( joy2_p9_i )
//);

joydecoder joystick_serial  (
    .clk          ( clk_sys ),
    .joy_data     ( joy_data_i ),
    .joy_clk      ( joy_clock_o ),
    .joy_load_n   ( joy_load_o ),

    .joy1up       ( joy1_up_i ),
    .joy1down     ( joy1_down_i ),
    .joy1left     ( joy1_left_i ),
    .joy1right    ( joy1_right_i ),
    .joy1fire1    ( joy1_p6_i ),
    .joy1fire2    ( joy1_p9_i ),

    .joy2up       ( joy2_up_i ),
    .joy2down     ( joy2_down_i ),
    .joy2left     ( joy2_left_i ),
    .joy2right    ( joy2_right_i ),
    .joy2fire1    ( joy2_p6_i ),
    .joy2fire2    ( joy2_p9_i )
); 




////////////////////   CLOCKS   ///////////////////

wire pll_locked, clk_pump;
wire clk_48M, clk_hdmi;
wire clk_sys = clk_hdmi;

pll pll
(
    .inclk0(clock_50_i),
    .c0(clk_48M), //49
    .c1(clk_hdmi), //24.5
    .c2(clk_pump),
    .locked(pll_locked)
);

wire clk_25m2,clk_40;
pll_vga pll_vga(
    .inclk0(clock_50_i),
    .c0(clk_25m2),
    .c1(clk_40)
    );

///////////////////////////////////////////////////

wire [31:0] status;
wire  [1:0] buttons;
wire        forced_scandoubler;

wire        ioctl_download;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;

wire [10:0] ps2_key;
wire [15:0] joystk1, joystk2;

/*
hps_io #(.STRLEN($size(CONF_STR)>>3)) hps_io
(
    .clk_sys(clk_sys),
    .HPS_BUS(HPS_BUS),

    .conf_str(CONF_STR),

    .buttons(buttons),
    .status(status),
    .forced_scandoubler(forced_scandoubler),

    .ioctl_download(ioctl_download),
    .ioctl_wr(ioctl_wr),
    .ioctl_addr(ioctl_addr),
    .ioctl_dout(ioctl_dout),

    .joystick_0(joystk1),
    .joystick_1(joystk2),
    .ps2_key(ps2_key)
);
*/

data_io #(
    .STRLEN(($size(CONF_STR)>>3)))
data_io(
    .clk_sys       ( clk_sys      ),
    .SPI_SCK       ( SPI_SCK      ),
    .SPI_SS2       ( SPI_SS2      ),
    .SPI_DI        ( SPI_DI       ),
    .SPI_DO        ( SPI_DO       ),
    
    .data_in       ( osd_s & keys_s ),
    .conf_str      ( CONF_STR     ),
    .status        ( status       ),
    
    .ioctl_download( ioctl_download  ),
    .ioctl_index   (   ),
    .ioctl_wr      ( ioctl_wr     ),
    .ioctl_addr    ( ioctl_addr   ),
    .ioctl_dout    ( ioctl_dout   )
);

//wire bCabinet  = status[19];
wire bCabinet  = 1'b0;  // (upright only)



///////////////////////////////////////////////////

wire hblank, vblank;
wire ce_vid;
wire hs, vs;
wire [3:0] r,g,b;

reg ce_pix;
always @(posedge clk_hdmi) begin
    reg old_clk;
    old_clk <= ce_vid;
    ce_pix  <= old_clk & ~ce_vid;
end


//=================================
wire [7:0] vga_col_s;
wire vga_hs_s, vga_vs_s;

framebuffer #(288,224,8) framebuffer
(
        .clk_sys    ( clk_hdmi ),
        .clk_i      ( PCLK ),
        .RGB_i      ((blankn) ? {r[3:1],g[3:1],b[3:2]} : 8'b00000000 ),//idx_color_s ),
        .hblank_i   ( hblank ),
        .vblank_i   ( vblank ),
        
        .rotate_i   ( status[8:7] ), 

        .clk_vga_i  ( (status[7]) ? clk_40 : clk_25m2 ), //800x600 or 640x480
        .RGB_o      ( vga_col_s ),
        .hsync_o    ( vga_hs_s ),
        .vsync_o    ( vga_vs_s ),
        .blank_o    (  ),

        .odd_line_o (  )
);


//=================================
/*
assign VGA_R = {r, 2'b00};
assign VGA_G = {g, 2'b00};
assign VGA_B = {b, 3'b000};
assign VGA_HS = hs;
assign VGA_VS = vs;
*/


wire blankn = ~(hblank | vblank);
wire direct_video_s = ~status[9] ^ direct_video;

mist_video #(.COLOR_DEPTH(3), .SD_HCNT_WIDTH(10), .USE_FRAMEBUFFER(1)) mist_video
(
    .clk_sys ( direct_video_s ? clk_hdmi : (status[7]) ? clk_40 : clk_25m2 ),
    .SPI_SCK ( SPI_SCK ),
    .SPI_SS3 ( SPI_SS2 ),
    .SPI_DI  ( SPI_DI  ),

    // video input 
    .R      ( (direct_video_s) ? (blankn) ? r  : 3'b000 : vga_col_s[7:5] ),
    .G      ( (direct_video_s) ? (blankn) ? g  : 3'b000 : vga_col_s[4:2] ),
    .B      ( (direct_video_s) ? (blankn) ? b  : 3'b000 : {vga_col_s[1:0], vga_col_s[0]} ),
    .HSync  ( (direct_video_s) ? hs : vga_hs_s ),
    .VSync  ( (direct_video_s) ? vs : vga_vs_s ),

    // video output 
    .VGA_R  ( VGA_R  ),
    .VGA_G  ( VGA_G  ),
    .VGA_B  ( VGA_B  ),
//    .VGA_R  ( vga_r_o  ),
//    .VGA_G  ( vga_g_o  ),
//    .VGA_B  ( vga_b_o  ),
    .VGA_HS ( VGA_HS ),
    .VGA_VS ( VGA_VS ),

    .ce_divider ( 1'b1 ),
    .blend      ( status[5] ),
    .rotate     ( osd_rotate ),
    .scanlines  ( status[4:3] ),
    .scandoubler_disable( direct_video_s ),
    .osd_enable ( osd_enable )
);



/*

mist_video #(.COLOR_DEPTH(3),.SD_HCNT_WIDTH(10)) mist_video
(
    .clk_sys(clk_hdmi),
    .SPI_SCK(SPI_SCK),
    .SPI_SS3(SPI_SS2),
    .SPI_DI(SPI_DI),

    .R              ( r ),
    .G              ( g ),
    .B              ( b ),
    .HSync          ( hs ),
    .VSync          ( vs ),

    // video output 
    .VGA_R  ( VGA_R  ),
    .VGA_G  ( VGA_G  ),
    .VGA_B  ( VGA_B  ),
    .VGA_HS ( VGA_HS ),
    .VGA_VS ( VGA_VS ),

    .rotate({2'b00}),
    .ce_divider(1'b1),
    .blend(status[5]),
    .scandoubler_disable(0),
    .scanlines(status[4:3]),
    .osd_enable(osd_enable)
);
*/


/*
arcade_rotate_fx #(288,224,12,0) arcade_video
(
    .*,

    .clk_video(clk_hdmi),

    .RGB_in({r,g,b}),
    .HBlank(hblank),
    .VBlank(vblank),
    .HSync(~hs),
    .VSync(~vs),

    .fx(status[5:3]),
    .no_rotate(status[2])
);
*/
wire        PCLK;
wire  [8:0] HPOS,VPOS;
wire [11:0] POUT;
HVGEN hvgen
(
    .HPOS(HPOS),.VPOS(VPOS),.PCLK(PCLK),.iRGB(POUT),
    .oRGB({b,g,r}),.HBLK(hblank),.VBLK(vblank),.HSYN(hs),.VSYN(vs)
);
assign ce_vid = PCLK;





///////////////////////////////////////////////////

//wire iRST =  status[0] | ~btn_n_i[4] | ioctl_download;
wire iRST =  status[0] | ioctl_download;

wire  [1:0] COIA = 2'b00;               // 1coin/1credit
wire  [1:0] COIB = 2'b00;               // 1coin/1credit

wire  [2:0] DIFF = status[21:19]; //10:8
wire  [1:0] LIFE = status[12:11];
wire  [2:0] EXTD = status[15:13]; 
wire        ADVN = status[16];
wire        DEMO = status[17];
wire        SERV = status[18];      // Service-SW
wire        CABI = bCabinet;

wire  [7:0] DSW0 = {LIFE,COIA,DEMO,1'b0,COIB};
wire  [7:0] DSW1 = {SERV,DIFF,ADVN,EXTD};
wire  [7:0] DSW2 = {6'h0,~SERV,~CABI};

wire  [4:0] INP0 = { m_fireA, m_left, m_down, m_right, m_up };
wire  [4:0] INP1 = { m_fire2A, m_left2, m_down2, m_right2, m_up2 };
wire  [2:0] INP2 = { btn_coin, btn_two_players, btn_one_player };


wire  [7:0] oSND;

FPGA_GAPLUS GameCore ( 
    .RESET(iRST),.MCLK(clk_48M),
    .PH(HPOS),.PV(VPOS),.PCLK(PCLK),.POUT(POUT),
    .SOUT(oSND),

    .INP0(INP0),.INP1(INP1),.INP2(INP2),
    .DSW0(DSW0),.DSW1(DSW1),.DSW2(DSW2),
    
    .ROMCL(clk_48M),.ROMAD(ioctl_addr[17:0]),.ROMDT(ioctl_dout),.ROMEN(ioctl_wr)
);

wire [15:0] AOUT;
assign AUDIO_R = AUDIO_L;
assign AOUT = {oSND,8'h0};

dac #(
    .C_bits(16))
dac(
    .clk_i(clk_sys),
    .res_n_i(1),
    .dac_i(AOUT),
    .dac_o(AUDIO_L)
    );

//--------- ROM DATA PUMP ----------------------------------------------------
    
        reg [15:0] power_on_s = 16'b1111111111111111;
        reg [7:0] osd_s = 8'b11111111;
        
        wire hard_reset = ~pll_locked;
        
        //--start the microcontroller OSD menu after the power on
        always @(posedge clk_sys) 
        begin
        
                if (hard_reset == 1)
                    power_on_s = 16'b1111111111111111;
                else if (power_on_s != 0)
                begin
                    power_on_s = power_on_s - 1;
                    osd_s = 8'b00111111;
                end 
                    
                
                if (ioctl_download == 1 && osd_s == 8'b00111111)
                    osd_s = 8'b11111111;
            
        end 

//-----------------------


wire m_up, m_down, m_left, m_right, m_fireA, m_fireB, m_fireC, m_fireD, m_fireE, m_fireF, m_fireG;
wire m_up2, m_down2, m_left2, m_right2, m_fire2A, m_fire2B, m_fire2C, m_fire2D, m_fire2E, m_fire2F, m_fire2G;
wire m_tilt, m_coin1, m_coin2, m_coin3, m_coin4, m_one_player, m_two_players, m_three_players, m_four_players;

wire m_right4, m_left4, m_down4, m_up4, m_right3, m_left3, m_down3, m_up3;

//wire btn_one_player  = ~btn_n_i[1] | m_one_player;
//wire btn_two_players = ~btn_n_i[2] | m_two_players;
//wire btn_coin        = ~btn_n_i[3] | m_coin1;

wire btn_one_player  = m_one_player;
wire btn_two_players = m_two_players;
wire btn_coin        = m_coin1;


wire kbd_intr;
wire [7:0] kbd_scancode;
wire [7:0] keys_s;

//get scancode from keyboard
io_ps2_keyboard keyboard 
 (
  .clk       ( clk_sys ),
  .kbd_clk   ( ps2_clk_io ),
  .kbd_dat   ( ps2_data_io ),
  .interrupt ( kbd_intr ),
  .scancode  ( kbd_scancode )
);

wire [15:0]joy1_s;
wire [15:0]joy2_s;
wire [8:0]controls_s;
wire osd_enable;
wire direct_video;
wire [1:0]osd_rotate;

//translate scancode to joystick
kbd_joystick #( .OSD_CMD    ( 3'b011 )) k_joystick
(
    .clk          ( clk_sys ),
    .kbdint       ( kbd_intr ),
    .kbdscancode  ( kbd_scancode ), 

    .joystick_0   ({ joy1_p6_i, joy1_p9_i, joy1_up_i, joy1_down_i, joy1_left_i, joy1_right_i }),
    .joystick_1   ({ joy2_p6_i, joy2_p9_i, joy2_up_i, joy2_down_i, joy2_left_i, joy2_right_i }),
      
    //-- joystick_0 and joystick_1 should be swapped
    .joyswap      ( 0 ),

    //-- player1 and player2 should get both joystick_0 and joystick_1
    .oneplayer    ( 1 ),

    //-- tilt, coin4-1, start4-1
    .controls     ( {m_tilt, m_coin4, m_coin3, m_coin2, m_coin1, m_four_players, m_three_players, m_two_players, m_one_player} ),

    //-- fire12-1, up, down, left, right

    .player1      ( {m_fireG,  m_fireF, m_fireE, m_fireD, m_fireC, m_fireB, m_fireA, m_up, m_down, m_left, m_right} ),
    .player2      ( {m_fire2G, m_fire2F, m_fire2E, m_fire2D, m_fire2C, m_fire2B, m_fire2A, m_up2, m_down2, m_left2, m_right2} ),

    .direct_video ( direct_video ),
    .osd_rotate   ( osd_rotate ),

    //-- keys to the OSD
    .osd_o        ( keys_s ),
    .osd_enable   ( osd_enable ),

    //-- sega joystick
    .sega_clk     ( hs ),
    .sega_strobe  ( joy_p7_o )

        
);

endmodule


module HVGEN
(
    output  [8:0]       HPOS,
    output  [8:0]       VPOS,
    input               PCLK,
    input   [11:0]      iRGB,

    output reg [11:0]   oRGB,
    output reg          HBLK = 1,
    output reg          VBLK = 1,
    output reg          HSYN = 1,
    output reg          VSYN = 1
);

reg [8:0] hcnt = 0;
reg [8:0] vcnt = 0;

assign HPOS = hcnt;
assign VPOS = vcnt;

always @(posedge PCLK) begin
    case (hcnt)
          0: begin HBLK <= 0; hcnt <= hcnt+1; end
        289: begin HBLK <= 1; hcnt <= hcnt+1; end
        311: begin HSYN <= 0; hcnt <= hcnt+1; end
        342: begin HSYN <= 1; hcnt <= 471;    end
        511: begin hcnt <= 0;
            case (vcnt)
                223: begin VBLK <= 1; vcnt <= vcnt+1; end
                226: begin VSYN <= 0; vcnt <= vcnt+1; end
                233: begin VSYN <= 1; vcnt <= 483;    end
                511: begin VBLK <= 0; vcnt <= 0;          end
                default: vcnt <= vcnt+1;
            endcase
        end
        default: hcnt <= hcnt+1;
    endcase
    oRGB <= (HBLK|VBLK) ? 12'h0 : iRGB;
end



endmodule

