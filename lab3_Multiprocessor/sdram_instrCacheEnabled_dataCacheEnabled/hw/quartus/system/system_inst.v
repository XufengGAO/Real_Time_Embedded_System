	system u0 (
		.clk_clk                       (<connected-to-clk_clk>),                       //                     clk.clk
		.cpu_0_custompio_0_parport     (<connected-to-cpu_0_custompio_0_parport>),     //       cpu_0_custompio_0.parport
		.cpu_0_led_export              (<connected-to-cpu_0_led_export>),              //               cpu_0_led.export
		.cpu_1_custompio_0_parport     (<connected-to-cpu_1_custompio_0_parport>),     //       cpu_1_custompio_0.parport
		.cpu_1_led_export              (<connected-to-cpu_1_led_export>),              //               cpu_1_led.export
		.pll_0_outclk2_clk             (<connected-to-pll_0_outclk2_clk>),             //           pll_0_outclk2.clk
		.reset_reset_n                 (<connected-to-reset_reset_n>),                 //                   reset.reset_n
		.sdram_controller_0_wire_addr  (<connected-to-sdram_controller_0_wire_addr>),  // sdram_controller_0_wire.addr
		.sdram_controller_0_wire_ba    (<connected-to-sdram_controller_0_wire_ba>),    //                        .ba
		.sdram_controller_0_wire_cas_n (<connected-to-sdram_controller_0_wire_cas_n>), //                        .cas_n
		.sdram_controller_0_wire_cke   (<connected-to-sdram_controller_0_wire_cke>),   //                        .cke
		.sdram_controller_0_wire_cs_n  (<connected-to-sdram_controller_0_wire_cs_n>),  //                        .cs_n
		.sdram_controller_0_wire_dq    (<connected-to-sdram_controller_0_wire_dq>),    //                        .dq
		.sdram_controller_0_wire_dqm   (<connected-to-sdram_controller_0_wire_dqm>),   //                        .dqm
		.sdram_controller_0_wire_ras_n (<connected-to-sdram_controller_0_wire_ras_n>), //                        .ras_n
		.sdram_controller_0_wire_we_n  (<connected-to-sdram_controller_0_wire_we_n>),  //                        .we_n
		.shared_pio_output_parport     (<connected-to-shared_pio_output_parport>)      //       shared_pio_output.parport
	);

