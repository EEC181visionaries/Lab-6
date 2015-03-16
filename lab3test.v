// Team Visionaries
// Philip Chan, Jessica Ma, Chan Lu
// Project Demo

module lab3test(
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pins
	input CLOCK_50,
	input CLOCK2_50,
	
	input [3:0] KEY,							//	Pushbutton[3:0]
	
	input [9:0] SW,							//	Toggle Switch[17:0]	
	
	// Seven Segment Displays
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,

	// LEDs
	output [9:0] LEDR,
	// SDRAM
	output [11:0] DRAM_ADDR,
	output [1:0] DRAM_BA,
	output DRAM_CAS_N,
	output DRAM_CKE,
	output DRAM_CLK,
	output DRAM_CS_N,
	inout [15:0] DRAM_DQ,
	output DRAM_LDQM,
	output DRAM_RAS_N,
	output DRAM_UDQM,
	output DRAM_WE_N,	
	
	// VGA
	output	[7:0] VGA_B,
	output 			VGA_BLANK_N,
	output 			VGA_CLK,
	output 	[7:0] VGA_G,
	output 			VGA_HS,
	output 	[7:0] VGA_R,
	output 			VGA_SYNC_N,
	output 			VGA_VS,
	
	// DDR3
	output      [14:0] HPS_DDR3_ADDR,
	output      [2:0]  HPS_DDR3_BA,
	output             HPS_DDR3_CAS_N,
	output             HPS_DDR3_CKE,
	output             HPS_DDR3_CK_N,
	output             HPS_DDR3_CK_P,
	output             HPS_DDR3_CS_N,
	output      [3:0]  HPS_DDR3_DM,
	inout       [31:0] HPS_DDR3_DQ,
	inout       [3:0]  HPS_DDR3_DQS_N,
	inout       [3:0]  HPS_DDR3_DQS_P,
	output             HPS_DDR3_ODT,
	output             HPS_DDR3_RAS_N,
	output             HPS_DDR3_RESET_N,
	input              HPS_DDR3_RZQ,
	output             HPS_DDR3_WE_N,
	
	// GPIO
	inout [35:0] GPIO_1							//	GPIO Connection 1
);


//=======================================================
//  REG/WIRE declarations
//=======================================================

//	CCD
wire	[11:0]	CCD_DATA;
wire			CCD_SDAT;
wire			CCD_SCLK;
wire			CCD_FLASH;
wire			CCD_FVAL;
wire			CCD_LVAL;
wire			CCD_PIXCLK;
wire			CCD_MCLK;				//	CCD Master Clock

wire		[15:0]	Read_DATA1;
wire		[15:0]	Read_DATA2;
wire		[15:0]	vga_read_DATA1;
wire		[15:0]	vga_read_DATA2;
wire		[15:0]	sdram_read_DATA1;
wire		[15:0]	sdram_read_DATA2;
wire					VGA_CTRL_CLK;
wire		[11:0]	mCCD_DATA;
wire					mCCD_DVAL;
wire					mCCD_DVAL_d;
wire		[15:0]	X_Cont;
wire		[15:0]	Y_Cont;
wire		[9:0]		X_ADDR;
wire		[31:0]	Frame_Cont;
wire					DLY_RST_0;
wire					DLY_RST_1;
wire					DLY_RST_2;
reg					Read;
wire					vga_read;
wire					sdram_read;
reg		[11:0]	rCCD_DATA;
reg					rCCD_LVAL;
reg					rCCD_FVAL;
wire		[11:0]	sCCD_R;
wire		[11:0]	sCCD_G;
wire		[11:0]	sCCD_B;
wire					sCCD_DVAL;
reg		[1:0]		rClk;
wire					sdram_ctrl_clk;
wire		[9:0]		oVGA_R;   				//	VGA Red[9:0]
wire		[9:0]		oVGA_G;	 				//	VGA Green[9:0]
wire		[9:0]		oVGA_B;   				//	VGA Blue[9:0]
wire					hps_clk_in;
wire					start_cam;
wire					stop_cam;
wire					source_select;
assign stop_cam = !start_cam;
reg					custom_clock;
reg 		[16:0]		gray;					// Converts VGA color to grayscale
wire		[1:0]		controlled_clk;
wire					HPS_CTRLING_CLK;
wire 		[1:0]		controlled_read;
// muxed clock
assign controlled_clk[0] = VGA_CTRL_CLK;
assign controlled_clk[1] = read_clock;
// muxed read
assign controlled_read[1] = vga_read;
assign controlled_read[0] = sdram_read;

wire					read_select;
assign read_select = start_cam;
//=======================================================
//  Structural coding
//=======================================================

assign	CCD_DATA[0]	=	GPIO_1[13];
assign	CCD_DATA[1]	=	GPIO_1[12];
assign	CCD_DATA[2]	=	GPIO_1[11];
assign	CCD_DATA[3]	=	GPIO_1[10];
assign	CCD_DATA[4]	=	GPIO_1[9];
assign	CCD_DATA[5]	=	GPIO_1[8];
assign	CCD_DATA[6]	=	GPIO_1[7];
assign	CCD_DATA[7]	=	GPIO_1[6];
assign	CCD_DATA[8]	=	GPIO_1[5];
assign	CCD_DATA[9]	=	GPIO_1[4];
assign	CCD_DATA[10]=	GPIO_1[3];
assign	CCD_DATA[11]=	GPIO_1[1];
assign	GPIO_1[16]	=	CCD_MCLK;
assign	CCD_FVAL	=	GPIO_1[22];
assign	CCD_LVAL	=	GPIO_1[21]; 
//assign	CCD_PIXCLK	=	GPIO_1[0]; //PixCLK
assign	CCD_PIXCLK	= CCD_MCLK;
assign	GPIO_1[19]	=	1'b1;  // tRIGGER
assign	GPIO_1[17]	=	DLY_RST_1;

assign	VGA_CLK		=	VGA_CTRL_CLK;


//always@(posedge CLOCK_50)	rClk	<=	rClk+1;

//assign CCD_MCLK = rClk[0]; // 25MHZ

assign	LEDR[9:3]		=	Y_Cont;
assign	LEDR[0:0]		=	sdram_read;
assign 	LEDR[1:1]		=	vga_read;
assign	VGA_R		=	oVGA_R[9:2];
assign	VGA_G		=	oVGA_G[9:2];
assign	VGA_B		=	oVGA_B[9:2];



always@(posedge CCD_PIXCLK)
begin
	rCCD_DATA	<=	CCD_DATA;
	rCCD_LVAL	<=	CCD_LVAL;
	rCCD_FVAL	<=	CCD_FVAL;
end

// Unused here
reg		[31:0]	clock_test;
always@(posedge controlled_clk[source_select])
begin
	Read <= sdram_read;
	clock_test <= clock_test + 1;
end

// Converts RAW2RGB's data from color to grayscale
// Then stores into Sdram_Control_4Port 
// gray = (27*red + 91*green + 9*blue)/127
always@(posedge controlled_clk[source_select])
begin
	gray <= sCCD_R*27 + sCCD_G*91 + sCCD_B*9;
end

wire					read_clock;
reg		[2:0]		read_clock_reg;
reg					read_good;

// used to prevent switch bounce. read_clock is 4x as slow as HPS_CTRLING_CLK
assign read_clock = read_clock_reg[1];
always@(posedge HPS_CTRLING_CLK)
begin
	read_clock_reg = read_clock_reg + 1;
	read_good = read_clock_reg[1];
end



VGA_Controller		u1	(	//	Host Side
							.oRequest(vga_read),				// Read Request is sent to the SDRAM when the VGA pixel scan is at the correct x and y pixel location in the active area

							.iRed(Read_DATA2[9:0]),
							.iGreen({Read_DATA1[14:10],Read_DATA2[14:10]}),
							.iBlue(Read_DATA1[9:0]),
							
							//	VGA Side
							.oVGA_R(oVGA_R),
							.oVGA_G(oVGA_G),
							.oVGA_B(oVGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							//	Control Signal
							.iCLK(controlled_clk[source_select]),
							.iRST_N(DLY_RST_2)
							);

Reset_Delay			u2	(
							.iCLK(CLOCK_50),
							.iRST(KEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2)
						);

CCD_Capture			u3	(	
							.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(!KEY[3]|start_cam),// software controlled start and stop
							.iEND(!KEY[2]|stop_cam),
							.iCLK(CCD_PIXCLK),
							.iRST(DLY_RST_2)
						);

RAW2RGB				u4	(	
							.iCLK(CCD_PIXCLK),
							.iRST(DLY_RST_1),
							.iDATA(mCCD_DATA),
							.iDVAL(mCCD_DVAL),
							.oRed(sCCD_R),
							.oGreen(sCCD_G),
							.oBlue(sCCD_B),
							.oDVAL(sCCD_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont)
						);

SEG7_LUT_8 			u5	(	
							.oSEG0(HEX0),
							.oSEG1(HEX1),
							.oSEG2(HEX2),
							.oSEG3(HEX3),
							.oSEG4(),
							.oSEG5(),
							.oSEG6(),
							.oSEG7(),
							.iDIG (Frame_Cont[31:0])
						);

Sdram_Control_4Port	u7	(	
							//	HOST Side
						   .RESET_N(1'b1),
							.CLK(sdram_ctrl_clk),

							//	FIFO Write Side 1
							.WR1_DATA({1'b0,gray[16:12],gray[16:7]}),
							.WR1(sCCD_DVAL),
							.WR1_ADDR(0),					// Memory start for one section of the memory
							.WR1_MAX_ADDR(640*480),
							.WR1_LENGTH(256),
							.WR1_LOAD(!DLY_RST_0),
							.WR1_CLK(~CCD_PIXCLK),		// This clock is directly from the CCD Camera Module, the Camera controls the write to memory
							// CCD data is written on the falling edge of the CCD_PIXCLK

							//	FIFO Write Side 2
							.WR2_DATA(	{1'b0,gray[11:7],gray[16:7]}),
							.WR2(sCCD_DVAL),
							.WR2_ADDR(22'h100000),		// Memory start for the second section of memory - why can we not write data into one memory block?
							.WR2_MAX_ADDR(22'h100000+640*480),
							.WR2_LENGTH(256),
							.WR2_LOAD(!DLY_RST_0),
							.WR2_CLK(~CCD_PIXCLK),

							//	FIFO Read Side 1
						   .RD1_DATA(Read_DATA1),	// goes into hps
				        	.RD1(controlled_read[read_select]),	// hps controlled or vga controlled
				        	.RD1_ADDR(0),
							.RD1_MAX_ADDR(640*480),
							.RD1_LENGTH(256),
							.RD1_LOAD((!DLY_RST_0)|(!vga_read_DATA1)),	// used to reset sdram
							.RD1_CLK(~controlled_clk[source_select]),
							
							//	FIFO Read Side 2
						   .RD2_DATA(Read_DATA2),	// is unused
							.RD2(controlled_read[read_select]),
							.RD2_ADDR(22'h100000), // Memory start address
							.RD2_MAX_ADDR(22'h100000+640*480),	// Allocate enough space for whole 640 x 480 display
							.RD2_LENGTH(256),	// 8 bits long data storage
				        	.RD2_LOAD((!DLY_RST_0)|(!vga_read_DATA1)),
							.RD2_CLK(~controlled_clk[source_select]),
							
							//	SDRAM Side - Initialize the SDRAM - Can only initialize one per design
							// Qsys does not allow the allocation of more than one SDRAM connected to the same DE1-SOC DRAM pin
						   .SA(DRAM_ADDR),
						   .BA(DRAM_BA),
        					.CS_N(DRAM_CS_N),
        					.CKE(DRAM_CKE),
        					.RAS_N(DRAM_RAS_N),
        					.CAS_N(DRAM_CAS_N),
        					.WE_N(DRAM_WE_N),
        					.DQ(DRAM_DQ),
        					.DQM({DRAM_UDQM,DRAM_LDQM})
						);
						

I2C_CCD_Config 		u8	(	
							//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(DLY_RST_2),
							.iEXPOSURE_ADJ(KEY[1]),
							.iEXPOSURE_DEC_p(SW[0]),
							.iZOOM_MODE_SW(SW[9]),
							//	I2C Side
							.I2C_SCLK(GPIO_1[24]),
							.I2C_SDAT(GPIO_1[23])
						);						
						
	mysystem u0 (	  
        .sdram_clk_clk                (sdram_ctrl_clk),                //             sdram_clk.clk
        .dram_clk_clk                 (DRAM_CLK),                 //              dram_clk.clk
        .d5m_clk_clk                  (CCD_MCLK),                  //               d5m_clk.clk
        .vga_clk_clk                  (VGA_CTRL_CLK),                   //               vga_clk.clk
        .system_pll_0_refclk_clk      (CLOCK_50),      //   system_pll_0_refclk.clk
        .system_pll_0_reset_reset     (1'b0),      //    system_pll_0_reset.reset
		  .memory_mem_a       (HPS_DDR3_ADDR),       //    memory.mem_a
        .memory_mem_ba      (HPS_DDR3_BA),      //          .mem_ba
        .memory_mem_ck      (HPS_DDR3_CK_P),      //          .mem_ck
        .memory_mem_ck_n    (HPS_DDR3_CK_N),    //          .mem_ck_n
        .memory_mem_cke     (HPS_DDR3_CKE),     //          .mem_cke
        .memory_mem_cs_n    (HPS_DDR3_CS_N),    //          .mem_cs_n
        .memory_mem_ras_n   (HPS_DDR3_RAS_N),   //          .mem_ras_n
        .memory_mem_cas_n   (HPS_DDR3_CAS_N),   //          .mem_cas_n
        .memory_mem_we_n    (HPS_DDR3_WE_N),    //          .mem_we_n
        .memory_mem_reset_n (HPS_DDR3_RESET_N), //          .mem_reset_n
        .memory_mem_dq      (HPS_DDR3_DQ),      //          .mem_dq
        .memory_mem_dqs     (HPS_DDR3_DQS_P),     //          .mem_dqs
        .memory_mem_dqs_n   (HPS_DDR3_DQS_N),   //          .mem_dqs_n
        .memory_mem_odt     (HPS_DDR3_ODT),     //          .mem_odt
        .memory_mem_dm      (HPS_DDR3_DM),      //          .mem_dm
        .memory_oct_rzqin   (HPS_DDR3_RZQ),   //          .oct_rzqin
		  
		  
        .hps_read_out_export   (sdram_read),      //        hps_read_out.export
        .hps_read_in_export    (vga_read),     //      hps_read_out_1.export
		  // Repurposed as reset signal
		  .vga_data1_export         (vga_read_DATA1),         //           vga_data1.export
        .vga_data2_export         (vga_read_DATA2),         //           vga_data2.export
		  
		  // Reading in values as grayscale into hps
        .sdram_data1_export       ({6'b000000,Read_DATA1[9:0]}),       //         sdram_data1.export
		  // unused
        .sdram_data2_export       (sdram_read_DATA2),        //         sdram_data2.export
		  // not actually a clock anymore, repurposed
		  .vga_clk_in_export        (read_good),        //          vga_clk_in.export
		  
        .cam_start_export         (start_cam),        //           cam_start.export
		  .source_select_export		(source_select),
		  .clock_tester_export		(clock_test),
		  .hps_controlled_clk_export (HPS_CTRLING_CLK)  //  hps_controlled_clk.export
		  );

		  

endmodule
