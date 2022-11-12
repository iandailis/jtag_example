module pulse (
	input logic clk,
	input logic in,
	output logic out
);

logic pulse_flag;

assign out = in & ~pulse_flag;

always_ff @ (posedge clk) begin
	pulse_flag <= in;
end

endmodule
