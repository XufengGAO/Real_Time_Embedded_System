
module system (
	clk_clk,
	edge_detector_0_conduit_end_csx,
	edge_detector_0_conduit_end_dcx,
	edge_detector_0_conduit_end_data_out,
	edge_detector_0_conduit_end_rdx,
	edge_detector_0_conduit_end_lcd_reset,
	edge_detector_0_conduit_end_wrx,
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
	sdram_controller_0_wire_we_n);	

	input		clk_clk;
	output		edge_detector_0_conduit_end_csx;
	output		edge_detector_0_conduit_end_dcx;
	output	[15:0]	edge_detector_0_conduit_end_data_out;
	output		edge_detector_0_conduit_end_rdx;
	output		edge_detector_0_conduit_end_lcd_reset;
	output		edge_detector_0_conduit_end_wrx;
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
endmodule
