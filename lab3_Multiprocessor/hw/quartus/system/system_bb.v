
module system (
	clk_clk,
	cpu_0_custompio_0_parport,
	cpu_0_led_export,
	cpu_1_custompio_0_parport,
	cpu_1_led_export,
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
	inout	[7:0]	cpu_0_custompio_0_parport;
	output	[7:0]	cpu_0_led_export;
	inout	[7:0]	cpu_1_custompio_0_parport;
	output	[7:0]	cpu_1_led_export;
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
