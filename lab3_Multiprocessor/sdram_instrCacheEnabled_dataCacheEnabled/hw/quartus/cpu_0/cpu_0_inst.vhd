	component cpu_0 is
		port (
			clk_clk                       : in    std_logic                     := 'X';             -- clk
			cpu_0_custompio_0_parport     : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- parport
			cpu_0_led_export              : out   std_logic_vector(7 downto 0);                     -- export
			outgoing_master_waitrequest   : in    std_logic                     := 'X';             -- waitrequest
			outgoing_master_readdata      : in    std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			outgoing_master_readdatavalid : in    std_logic                     := 'X';             -- readdatavalid
			outgoing_master_burstcount    : out   std_logic_vector(0 downto 0);                     -- burstcount
			outgoing_master_writedata     : out   std_logic_vector(31 downto 0);                    -- writedata
			outgoing_master_address       : out   std_logic_vector(27 downto 0);                    -- address
			outgoing_master_write         : out   std_logic;                                        -- write
			outgoing_master_read          : out   std_logic;                                        -- read
			outgoing_master_byteenable    : out   std_logic_vector(3 downto 0);                     -- byteenable
			outgoing_master_debugaccess   : out   std_logic;                                        -- debugaccess
			reset_reset_n                 : in    std_logic                     := 'X'              -- reset_n
		);
	end component cpu_0;

	u0 : component cpu_0
		port map (
			clk_clk                       => CONNECTED_TO_clk_clk,                       --               clk.clk
			cpu_0_custompio_0_parport     => CONNECTED_TO_cpu_0_custompio_0_parport,     -- cpu_0_custompio_0.parport
			cpu_0_led_export              => CONNECTED_TO_cpu_0_led_export,              --         cpu_0_led.export
			outgoing_master_waitrequest   => CONNECTED_TO_outgoing_master_waitrequest,   --   outgoing_master.waitrequest
			outgoing_master_readdata      => CONNECTED_TO_outgoing_master_readdata,      --                  .readdata
			outgoing_master_readdatavalid => CONNECTED_TO_outgoing_master_readdatavalid, --                  .readdatavalid
			outgoing_master_burstcount    => CONNECTED_TO_outgoing_master_burstcount,    --                  .burstcount
			outgoing_master_writedata     => CONNECTED_TO_outgoing_master_writedata,     --                  .writedata
			outgoing_master_address       => CONNECTED_TO_outgoing_master_address,       --                  .address
			outgoing_master_write         => CONNECTED_TO_outgoing_master_write,         --                  .write
			outgoing_master_read          => CONNECTED_TO_outgoing_master_read,          --                  .read
			outgoing_master_byteenable    => CONNECTED_TO_outgoing_master_byteenable,    --                  .byteenable
			outgoing_master_debugaccess   => CONNECTED_TO_outgoing_master_debugaccess,   --                  .debugaccess
			reset_reset_n                 => CONNECTED_TO_reset_reset_n                  --             reset.reset_n
		);

