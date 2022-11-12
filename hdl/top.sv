module top (
	input MAX10_CLK1_50,
	
	/* DE-10 I/O */
	input [1:0] KEY,
	input [9:0] SW,
	output [9:0] LEDR,
	
	/* HEX */
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5
	
	/* SDRAM */	
	// output DRAM_CLK,
	// output [12:0] DRAM_ADDR,
	// output [1:0] DRAM_BA,
	// output DRAM_CAS_N,
	// output DRAM_CKE,
	// output DRAM_CS_N,
	// inout [15:0] DRAM_DQ,
	// output DRAM_LDQM,
	// output DRAM_UDQM,
	// output DRAM_RAS_N,
	// output DRAM_WE_N,
	
	/* I/O BOARD */
	// inout [15:0] ARDUINO_IO,
	// inout ARDUINO_RESET_N,
	
	/* VGA OUTPUT */
	// output [3:0] VGA_R,
	// output [3:0] VGA_G,
	// output [3:0] VGA_B,
	// output VGA_HS,
	// output VGA_VS
);

logic Reset;
assign Reset = ~KEY[0];

logic [23:0] hex_in;

logic jtag_Act, jtag_WE;
logic jtag_R, jtag_A;
logic [7:0] jtag_Din;
logic [7:0] jtag_Dout;

logic jtag_R_pulse;

always_comb begin
	LEDR[9] = jtag_R;
	LEDR[8] = jtag_A;
	jtag_Din = SW[7:0];
	jtag_WE = SW[9];
	jtag_Act = jtag_A;
end

jtag_controller jtag (
	.Clk(MAX10_CLK1_50),
	.Reset(Reset),
	.Act(jtag_Act),
	.WE(jtag_WE),
	.R(jtag_R),
	.A(jtag_A),
	.Din(jtag_Din),
	.Dout(jtag_Dout)
);

shift_reg shift_reg (
	.clk(MAX10_CLK1_50),
	.rst(Reset),
	.shift(jtag_R_pulse),
	.din(jtag_Dout),
	.dout(hex_in)
);

pulse r_pulse(
	.clk(MAX10_CLK1_50),
	.in(jtag_R),
	.out(jtag_R_pulse)
);

hex_driver hex_drivers [5:0] (
	.in  (hex_in),
	.dp  ({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}),
	.out ({HEX5, HEX4, HEX3, HEX2, HEX1, HEX0})
);

endmodule
