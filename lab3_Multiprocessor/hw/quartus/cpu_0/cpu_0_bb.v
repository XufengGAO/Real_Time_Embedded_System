
module cpu_0 (
	clk_clk,
	cpu_0_custompio_0_parport,
	cpu_0_led_export,
	outgoing_master_waitrequest,
	outgoing_master_readdata,
	outgoing_master_readdatavalid,
	outgoing_master_burstcount,
	outgoing_master_writedata,
	outgoing_master_address,
	outgoing_master_write,
	outgoing_master_read,
	outgoing_master_byteenable,
	outgoing_master_debugaccess,
	reset_reset_n);	

	input		clk_clk;
	inout	[7:0]	cpu_0_custompio_0_parport;
	output	[7:0]	cpu_0_led_export;
	input		outgoing_master_waitrequest;
	input	[31:0]	outgoing_master_readdata;
	input		outgoing_master_readdatavalid;
	output	[0:0]	outgoing_master_burstcount;
	output	[31:0]	outgoing_master_writedata;
	output	[27:0]	outgoing_master_address;
	output		outgoing_master_write;
	output		outgoing_master_read;
	output	[3:0]	outgoing_master_byteenable;
	output		outgoing_master_debugaccess;
	input		reset_reset_n;
endmodule
