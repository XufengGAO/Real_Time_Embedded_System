
module system (
	clk_clk,
	led_0_output_parport,
	led_1_output_parport,
	pio_0_external_connection_export,
	pio_1_external_connection_export,
	pll_0_outclk2_clk,
	reset_reset_n,
	sdram_controller_0_wire_addr,
	sdram_controller_0_wire_ba,
	sdram_controller_0_wire_cas_n,
	sdram_controller_0_wire_cke,
	sdram_controller_0_wire_cs_n,
	sdram_controller_0_wire_dq,
	sdram_controller_0_wire_dqm,
	sdram_controller_0_wire_ras_n,
	sdram_controller_0_wire_we_n,
	shared_pio_output_parport);	

	input		clk_clk;
	inout	[7:0]	led_0_output_parport;
	inout	[7:0]	led_1_output_parport;
	output	[7:0]	pio_0_external_connection_export;
	output	[7:0]	pio_1_external_connection_export;
	output		pll_0_outclk2_clk;
	input		reset_reset_n;
	output	[12:0]	sdram_controller_0_wire_addr;
	output	[1:0]	sdram_controller_0_wire_ba;
	output		sdram_controller_0_wire_cas_n;
	output		sdram_controller_0_wire_cke;
	output		sdram_controller_0_wire_cs_n;
	inout	[15:0]	sdram_controller_0_wire_dq;
	output	[1:0]	sdram_controller_0_wire_dqm;
	output		sdram_controller_0_wire_ras_n;
	output		sdram_controller_0_wire_we_n;
	inout	[7:0]	shared_pio_output_parport;
endmodule
