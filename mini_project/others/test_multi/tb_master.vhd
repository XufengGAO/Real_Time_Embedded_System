library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity tb_master is
end tb_master;
 
architecture simulation of tb_master is
 
  component edge_detection is
  port (
    -- clock interface
    csi_clock_clk : in std_logic;
	  csi_clock_reset_n : in std_logic;
	
	  -- master part
	  avm_read_master_address : out std_logic_vector (31 downto 0);
	  avm_read_master_byteenable : out std_logic_vector (3 downto 0);
	  avm_read_master_read : out std_logic;
	  avm_read_master_readdata : in std_logic_vector (31 downto 0);
	  avm_read_master_waitrequest : in std_logic;
	
	
    -- control & status registers (CSR) slave
    avs_csr_address : in std_logic_vector (2 downto 0);
    avs_csr_read : in std_logic;
    avs_csr_readdata : out std_logic_vector (31 downto 0);
    avs_csr_write : in std_logic;
    avs_csr_writedata : in std_logic_vector (31 downto 0);


	  -- interface with FIFO
	  rgb_data : out std_logic_vector (15 downto 0);
	  write_fifo : out std_logic;
	  FIFO_full : in std_logic;


	  -- interface with LCD control
	  command_acquisition : out std_logic_vector (7 downto 0);
	  new_mode : out std_logic;
	  mode_ack : in std_logic;
	  lcd_mode_select : out std_logic_vector (2 downto 0)
  );
  end component edge_detection;
 
  signal r_CLOCK     : std_logic                    := '0';
  signal r_nreset    : std_logic                    := '1';

  -- read master
	signal r_avm_read_master_read : std_logic;
	signal r_avm_read_master_address : std_logic_vector (31 downto 0);
	signal r_avm_read_master_readdata : std_logic_vector (31 downto 0);
	signal r_avm_read_master_waitrequest : std_logic;
	signal r_avm_read_master_byteenable : std_logic_vector (3 downto 0);
	
	
	-- control & status registers (CSR) slave
	signal r_avs_csr_address : std_logic_vector (2 downto 0);
	signal r_avs_csr_read : std_logic;
	signal r_avs_csr_readdata : std_logic_vector (31 downto 0);
	signal r_avs_csr_write : std_logic;
	signal r_avs_csr_writedata : std_logic_vector (31 downto 0);


	-- interface with fifo
	signal r_rgb_data : std_logic_vector (15 downto 0);
	signal r_write_fifo : std_logic;
	signal r_full : std_logic;


	-- interface with LCD control
	signal r_command_acquisition : std_logic_vector (7 downto 0);
	signal r_new_mode : std_logic;
	signal r_mode_ack : std_logic;
	signal r_lcd_mode_select : std_logic_vector (2 downto 0);

begin
 
  -- Instantiate UART transmitter
  Detect_INST : edge_detection
  port map(
    csi_clock_clk => r_CLOCK,
	  csi_clock_reset_n => r_nreset,
	
	  -- read master
	  avm_read_master_read            => r_avm_read_master_read,
	  avm_read_master_address         => r_avm_read_master_address,
	  avm_read_master_readdata        => r_avm_read_master_readdata,
	  avm_read_master_waitrequest     => r_avm_read_master_waitrequest,
	  avm_read_master_byteenable      => r_avm_read_master_byteenable,
	
	
	  -- control & status registers (CSR) slave
	  avs_csr_address     => r_avs_csr_address,
	  avs_csr_read        => r_avs_csr_read,
	  avs_csr_readdata    => r_avs_csr_readdata,
	  avs_csr_write       => r_avs_csr_write,
	  avs_csr_writedata   => r_avs_csr_writedata,


	  -- interface with fifo
	  rgb_data    => r_rgb_data,
	  write_fifo  => r_write_fifo,
	  FIFO_full => r_full,


	  -- interface with LCD control
	  command_acquisition => r_command_acquisition,
	  new_mode            => r_new_mode,
	  mode_ack            => r_mode_ack,
	  lcd_mode_select     => r_lcd_mode_select
  );
 
  r_CLOCK <= not r_CLOCK after 10 ns;
   
  process is

    procedure async_reset is 
    begin
      wait until rising_edge(r_CLOCK);
      wait for 5 ns;
      r_nreset <= '0';
  
      wait for 10 ns;
      r_nreset <= '1';

    end procedure async_reset;

  begin
    wait for 100 ns;
    async_reset;
    wait for 100 ns;
  
    
    r_full <= '0';
    r_avs_csr_address <= "001";
    r_avs_csr_writedata <= X"0000002c";
    wait for 20 ns;
    r_avs_csr_write <= '1';

    wait for 40 ns;
    r_avs_csr_write <= '0';

    wait for 40 ns;
    r_avs_csr_address <= "000";
    r_avs_csr_writedata <= X"00000002";
    wait for 20 ns;
    r_avs_csr_write <= '1';

    wait for 120 ns;
    r_mode_ack <= '1';

    while r_new_mode = '1' loop
      wait for 10 ns;
    end loop;
    
    r_mode_ack <= '0';

    -- write read_address
    r_avs_csr_address <= "010";
    r_avs_csr_writedata <= X"00001000";
    wait for 20 ns;
    r_avs_csr_write <= '1';

    wait for 40 ns;
    r_avs_csr_write <= '0';


    r_avm_read_master_waitrequest <= '1';

    -- write start flag
    r_avs_csr_address <= "110";
    r_avs_csr_writedata <= X"00000001";
    wait for 20 ns;
    r_avs_csr_write <= '1';

    wait for 40 ns;
    r_avs_csr_write <= '0';

    wait for 200 ns;

    r_avm_read_master_waitrequest <= '0';
    FOR n IN 1 TO 50 LOOP
      r_avm_read_master_readdata <= std_logic_vector(to_unsigned(n * 8, r_avm_read_master_readdata'length));
      wait for 20 ns;
    end loop;



  end process;
   
end simulation;
