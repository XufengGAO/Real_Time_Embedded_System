	component system is
		port (
			clk_clk                               : in    std_logic                     := 'X';             -- clk
			edge_detector_0_conduit_end_csx       : out   std_logic;                                        -- csx
			edge_detector_0_conduit_end_dcx       : out   std_logic;                                        -- dcx
			edge_detector_0_conduit_end_data_out  : out   std_logic_vector(15 downto 0);                    -- data_out
			edge_detector_0_conduit_end_rdx       : out   std_logic;                                        -- rdx
			edge_detector_0_conduit_end_lcd_reset : out   std_logic;                                        -- lcd_reset
			edge_detector_0_conduit_end_wrx       : out   std_logic;                                        -- wrx
			pll_0_outclk2_clk                     : out   std_logic;                                        -- clk
			reset_reset_n                         : in    std_logic                     := 'X';             -- reset_n
			sdram_controller_0_wire_addr          : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_0_wire_ba            : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_0_wire_cas_n         : out   std_logic;                                        -- cas_n
			sdram_controller_0_wire_cke           : out   std_logic;                                        -- cke
			sdram_controller_0_wire_cs_n          : out   std_logic;                                        -- cs_n
			sdram_controller_0_wire_dq            : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_controller_0_wire_dqm           : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_controller_0_wire_ras_n         : out   std_logic;                                        -- ras_n
			sdram_controller_0_wire_we_n          : out   std_logic                                         -- we_n
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                         clk.clk
			edge_detector_0_conduit_end_csx       => CONNECTED_TO_edge_detector_0_conduit_end_csx,       -- edge_detector_0_conduit_end.csx
			edge_detector_0_conduit_end_dcx       => CONNECTED_TO_edge_detector_0_conduit_end_dcx,       --                            .dcx
			edge_detector_0_conduit_end_data_out  => CONNECTED_TO_edge_detector_0_conduit_end_data_out,  --                            .data_out
			edge_detector_0_conduit_end_rdx       => CONNECTED_TO_edge_detector_0_conduit_end_rdx,       --                            .rdx
			edge_detector_0_conduit_end_lcd_reset => CONNECTED_TO_edge_detector_0_conduit_end_lcd_reset, --                            .lcd_reset
			edge_detector_0_conduit_end_wrx       => CONNECTED_TO_edge_detector_0_conduit_end_wrx,       --                            .wrx
			pll_0_outclk2_clk                     => CONNECTED_TO_pll_0_outclk2_clk,                     --               pll_0_outclk2.clk
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --                       reset.reset_n
			sdram_controller_0_wire_addr          => CONNECTED_TO_sdram_controller_0_wire_addr,          --     sdram_controller_0_wire.addr
			sdram_controller_0_wire_ba            => CONNECTED_TO_sdram_controller_0_wire_ba,            --                            .ba
			sdram_controller_0_wire_cas_n         => CONNECTED_TO_sdram_controller_0_wire_cas_n,         --                            .cas_n
			sdram_controller_0_wire_cke           => CONNECTED_TO_sdram_controller_0_wire_cke,           --                            .cke
			sdram_controller_0_wire_cs_n          => CONNECTED_TO_sdram_controller_0_wire_cs_n,          --                            .cs_n
			sdram_controller_0_wire_dq            => CONNECTED_TO_sdram_controller_0_wire_dq,            --                            .dq
			sdram_controller_0_wire_dqm           => CONNECTED_TO_sdram_controller_0_wire_dqm,           --                            .dqm
			sdram_controller_0_wire_ras_n         => CONNECTED_TO_sdram_controller_0_wire_ras_n,         --                            .ras_n
			sdram_controller_0_wire_we_n          => CONNECTED_TO_sdram_controller_0_wire_we_n           --                            .we_n
		);

