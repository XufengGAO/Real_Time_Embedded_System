	component system is
		port (
			clk_clk                         : in    std_logic                    := 'X';             -- clk
			custompio_0_conduit_end_parport : inout std_logic_vector(7 downto 0) := (others => 'X'); -- parport
			reset_reset_n                   : in    std_logic                    := 'X'              -- reset_n
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                         => CONNECTED_TO_clk_clk,                         --                     clk.clk
			custompio_0_conduit_end_parport => CONNECTED_TO_custompio_0_conduit_end_parport, -- custompio_0_conduit_end.parport
			reset_reset_n                   => CONNECTED_TO_reset_reset_n                    --                   reset.reset_n
		);

