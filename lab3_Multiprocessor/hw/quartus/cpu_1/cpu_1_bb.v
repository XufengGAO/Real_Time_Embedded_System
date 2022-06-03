
module cpu_1 (
	clk_clk,
	reset_reset_n,
	mm_bridge_1_m0_waitrequest,
	mm_bridge_1_m0_readdata,
	mm_bridge_1_m0_readdatavalid,
	mm_bridge_1_m0_burstcount,
	mm_bridge_1_m0_writedata,
	mm_bridge_1_m0_address,
	mm_bridge_1_m0_write,
	mm_bridge_1_m0_read,
	mm_bridge_1_m0_byteenable,
	mm_bridge_1_m0_debugaccess,
	cpu_1_custompio_0_parport,
	cpu_1_led_export);	

	input		clk_clk;
	input		reset_reset_n;
	input		mm_bridge_1_m0_waitrequest;
	input	[31:0]	mm_bridge_1_m0_readdata;
	input		mm_bridge_1_m0_readdatavalid;
	output	[0:0]	mm_bridge_1_m0_burstcount;
	output	[31:0]	mm_bridge_1_m0_writedata;
	output	[27:0]	mm_bridge_1_m0_address;
	output		mm_bridge_1_m0_write;
	output		mm_bridge_1_m0_read;
	output	[3:0]	mm_bridge_1_m0_byteenable;
	output		mm_bridge_1_m0_debugaccess;
	inout	[7:0]	cpu_1_custompio_0_parport;
	output	[7:0]	cpu_1_led_export;
endmodule
