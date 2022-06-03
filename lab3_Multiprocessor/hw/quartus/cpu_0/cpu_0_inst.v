	cpu_0 u0 (
		.clk_clk                       (<connected-to-clk_clk>),                       //               clk.clk
		.cpu_0_custompio_0_parport     (<connected-to-cpu_0_custompio_0_parport>),     // cpu_0_custompio_0.parport
		.cpu_0_led_export              (<connected-to-cpu_0_led_export>),              //         cpu_0_led.export
		.outgoing_master_waitrequest   (<connected-to-outgoing_master_waitrequest>),   //   outgoing_master.waitrequest
		.outgoing_master_readdata      (<connected-to-outgoing_master_readdata>),      //                  .readdata
		.outgoing_master_readdatavalid (<connected-to-outgoing_master_readdatavalid>), //                  .readdatavalid
		.outgoing_master_burstcount    (<connected-to-outgoing_master_burstcount>),    //                  .burstcount
		.outgoing_master_writedata     (<connected-to-outgoing_master_writedata>),     //                  .writedata
		.outgoing_master_address       (<connected-to-outgoing_master_address>),       //                  .address
		.outgoing_master_write         (<connected-to-outgoing_master_write>),         //                  .write
		.outgoing_master_read          (<connected-to-outgoing_master_read>),          //                  .read
		.outgoing_master_byteenable    (<connected-to-outgoing_master_byteenable>),    //                  .byteenable
		.outgoing_master_debugaccess   (<connected-to-outgoing_master_debugaccess>),   //                  .debugaccess
		.reset_reset_n                 (<connected-to-reset_reset_n>)                  //             reset.reset_n
	);

