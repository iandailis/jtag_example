module shift_reg 
#(
	parameter DIN_WIDTH = 8,
	parameter DOUT_WIDTH = 24
)
(
	input logic clk, rst,
	input logic shift,
	input logic [DIN_WIDTH-1:0] din,
	output logic [DOUT_WIDTH-1:0] dout
);

always_ff @ (posedge clk or posedge rst) begin
	if (rst) begin
		dout <= '0;
	end else begin
		if (shift) begin
			dout <= {dout[DOUT_WIDTH-DIN_WIDTH-1:0], din};
		end
	end
end

endmodule