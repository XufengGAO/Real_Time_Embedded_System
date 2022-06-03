	cpu_1 u0 (
		.clk_clk                      (<connected-to-clk_clk>),                      //               clk.clk
		.reset_reset_n                (<connected-to-reset_reset_n>),                //             reset.reset_n
		.mm_bridge_1_m0_waitrequest   (<connected-to-mm_bridge_1_m0_waitrequest>),   //    mm_bridge_1_m0.waitrequest
		.mm_bridge_1_m0_readdata      (<connected-to-mm_bridge_1_m0_readdata>),      //                  .readdata
		.mm_bridge_1_m0_readdatavalid (<connected-to-mm_bridge_1_m0_readdatavalid>), //                  .readdatavalid
		.mm_bridge_1_m0_burstcount    (<connected-to-mm_bridge_1_m0_burstcount>),    //                  .burstcount
		.mm_bridge_1_m0_writedata     (<connected-to-mm_bridge_1_m0_writedata>),     //                  .writedata
		.mm_bridge_1_m0_address       (<connected-to-mm_bridge_1_m0_address>),       //                  .address
		.mm_bridge_1_m0_write         (<connected-to-mm_bridge_1_m0_write>),         //                  .write
		.mm_bridge_1_m0_read          (<connected-to-mm_bridge_1_m0_read>),          //                  .read
		.mm_bridge_1_m0_byteenable    (<connected-to-mm_bridge_1_m0_byteenable>),    //                  .byteenable
		.mm_bridge_1_m0_debugaccess   (<connected-to-mm_bridge_1_m0_debugaccess>),   //                  .debugaccess
		.cpu_1_custompio_0_parport    (<connected-to-cpu_1_custompio_0_parport>),    // cpu_1_custompio_0.parport
		.cpu_1_led_export             (<connected-to-cpu_1_led_export>)              //         cpu_1_led.export
	);

