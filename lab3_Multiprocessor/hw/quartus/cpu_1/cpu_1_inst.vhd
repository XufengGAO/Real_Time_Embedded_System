	component cpu_1 is
		port (
			clk_clk                      : in    std_logic                     := 'X';             -- clk
			reset_reset_n                : in    std_logic                     := 'X';             -- reset_n
			mm_bridge_1_m0_waitrequest   : in    std_logic                     := 'X';             -- waitrequest
			mm_bridge_1_m0_readdata      : in    std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			mm_bridge_1_m0_readdatavalid : in    std_logic                     := 'X';             -- readdatavalid
			mm_bridge_1_m0_burstcount    : out   std_logic_vector(0 downto 0);                     -- burstcount
			mm_bridge_1_m0_writedata     : out   std_logic_vector(31 downto 0);                    -- writedata
			mm_bridge_1_m0_address       : out   std_logic_vector(27 downto 0);                    -- address
			mm_bridge_1_m0_write         : out   std_logic;                                        -- write
			mm_bridge_1_m0_read          : out   std_logic;                                        -- read
			mm_bridge_1_m0_byteenable    : out   std_logic_vector(3 downto 0);                     -- byteenable
			mm_bridge_1_m0_debugaccess   : out   std_logic;                                        -- debugaccess
			cpu_1_custompio_0_parport    : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- parport
			cpu_1_led_export             : out   std_logic_vector(7 downto 0)                      -- export
		);
	end component cpu_1;

	u0 : component cpu_1
		port map (
			clk_clk                      => CONNECTED_TO_clk_clk,                      --               clk.clk
			reset_reset_n                => CONNECTED_TO_reset_reset_n,                --             reset.reset_n
			mm_bridge_1_m0_waitrequest   => CONNECTED_TO_mm_bridge_1_m0_waitrequest,   --    mm_bridge_1_m0.waitrequest
			mm_bridge_1_m0_readdata      => CONNECTED_TO_mm_bridge_1_m0_readdata,      --                  .readdata
			mm_bridge_1_m0_readdatavalid => CONNECTED_TO_mm_bridge_1_m0_readdatavalid, --                  .readdatavalid
			mm_bridge_1_m0_burstcount    => CONNECTED_TO_mm_bridge_1_m0_burstcount,    --                  .burstcount
			mm_bridge_1_m0_writedata     => CONNECTED_TO_mm_bridge_1_m0_writedata,     --                  .writedata
			mm_bridge_1_m0_address       => CONNECTED_TO_mm_bridge_1_m0_address,       --                  .address
			mm_bridge_1_m0_write         => CONNECTED_TO_mm_bridge_1_m0_write,         --                  .write
			mm_bridge_1_m0_read          => CONNECTED_TO_mm_bridge_1_m0_read,          --                  .read
			mm_bridge_1_m0_byteenable    => CONNECTED_TO_mm_bridge_1_m0_byteenable,    --                  .byteenable
			mm_bridge_1_m0_debugaccess   => CONNECTED_TO_mm_bridge_1_m0_debugaccess,   --                  .debugaccess
			cpu_1_custompio_0_parport    => CONNECTED_TO_cpu_1_custompio_0_parport,    -- cpu_1_custompio_0.parport
			cpu_1_led_export             => CONNECTED_TO_cpu_1_led_export              --         cpu_1_led.export
		);

