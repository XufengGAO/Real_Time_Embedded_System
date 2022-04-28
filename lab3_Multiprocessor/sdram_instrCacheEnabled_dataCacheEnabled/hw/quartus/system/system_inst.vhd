	component system is
		port (
			clk_clk                          : in    std_logic                     := 'X';             -- clk
			led_0_output_parport             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- parport
			led_1_output_parport             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- parport
			pio_0_external_connection_export : out   std_logic_vector(7 downto 0);                     -- export
			pio_1_external_connection_export : out   std_logic_vector(7 downto 0);                     -- export
			pll_0_outclk2_clk                : out   std_logic;                                        -- clk
			reset_reset_n                    : in    std_logic                     := 'X';             -- reset_n
			sdram_controller_0_wire_addr     : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_0_wire_ba       : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_0_wire_cas_n    : out   std_logic;                                        -- cas_n
			sdram_controller_0_wire_cke      : out   std_logic;                                        -- cke
			sdram_controller_0_wire_cs_n     : out   std_logic;                                        -- cs_n
			sdram_controller_0_wire_dq       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_controller_0_wire_dqm      : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_controller_0_wire_ras_n    : out   std_logic;                                        -- ras_n
			sdram_controller_0_wire_we_n     : out   std_logic;                                        -- we_n
			shared_pio_output_parport        : inout std_logic_vector(7 downto 0)  := (others => 'X')  -- parport
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                          => CONNECTED_TO_clk_clk,                          --                       clk.clk
			led_0_output_parport             => CONNECTED_TO_led_0_output_parport,             --              led_0_output.parport
			led_1_output_parport             => CONNECTED_TO_led_1_output_parport,             --              led_1_output.parport
			pio_0_external_connection_export => CONNECTED_TO_pio_0_external_connection_export, -- pio_0_external_connection.export
			pio_1_external_connection_export => CONNECTED_TO_pio_1_external_connection_export, -- pio_1_external_connection.export
			pll_0_outclk2_clk                => CONNECTED_TO_pll_0_outclk2_clk,                --             pll_0_outclk2.clk
			reset_reset_n                    => CONNECTED_TO_reset_reset_n,                    --                     reset.reset_n
			sdram_controller_0_wire_addr     => CONNECTED_TO_sdram_controller_0_wire_addr,     --   sdram_controller_0_wire.addr
			sdram_controller_0_wire_ba       => CONNECTED_TO_sdram_controller_0_wire_ba,       --                          .ba
			sdram_controller_0_wire_cas_n    => CONNECTED_TO_sdram_controller_0_wire_cas_n,    --                          .cas_n
			sdram_controller_0_wire_cke      => CONNECTED_TO_sdram_controller_0_wire_cke,      --                          .cke
			sdram_controller_0_wire_cs_n     => CONNECTED_TO_sdram_controller_0_wire_cs_n,     --                          .cs_n
			sdram_controller_0_wire_dq       => CONNECTED_TO_sdram_controller_0_wire_dq,       --                          .dq
			sdram_controller_0_wire_dqm      => CONNECTED_TO_sdram_controller_0_wire_dqm,      --                          .dqm
			sdram_controller_0_wire_ras_n    => CONNECTED_TO_sdram_controller_0_wire_ras_n,    --                          .ras_n
			sdram_controller_0_wire_we_n     => CONNECTED_TO_sdram_controller_0_wire_we_n,     --                          .we_n
			shared_pio_output_parport        => CONNECTED_TO_shared_pio_output_parport         --         shared_pio_output.parport
		);

