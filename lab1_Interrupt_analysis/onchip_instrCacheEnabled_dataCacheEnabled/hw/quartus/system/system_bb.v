
module system (
	clk_clk,
	custom_pio_0_conduit_end_parport,
	pio_0_export,
	reset_reset_n);	

	input		clk_clk;
	inout	[7:0]	custom_pio_0_conduit_end_parport;
	input	[3:0]	pio_0_export;
	input		reset_reset_n;
endmodule
