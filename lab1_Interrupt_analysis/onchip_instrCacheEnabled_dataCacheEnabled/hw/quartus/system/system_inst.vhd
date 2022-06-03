	component system is
		port (
			clk_clk                          : in    std_logic                    := 'X';             -- clk
			custom_pio_0_conduit_end_parport : inout std_logic_vector(7 downto 0) := (others => 'X'); -- parport
			pio_0_export                     : in    std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n                    : in    std_logic                    := 'X'              -- reset_n
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                          => CONNECTED_TO_clk_clk,                          --                      clk.clk
			custom_pio_0_conduit_end_parport => CONNECTED_TO_custom_pio_0_conduit_end_parport, -- custom_pio_0_conduit_end.parport
			pio_0_export                     => CONNECTED_TO_pio_0_export,                     --                    pio_0.export
			reset_reset_n                    => CONNECTED_TO_reset_reset_n                     --                    reset.reset_n
		);

