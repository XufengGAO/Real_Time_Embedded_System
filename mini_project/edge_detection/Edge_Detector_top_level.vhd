library ieee;
use ieee.std_logic_1164.ALL;

entity LCD_Cotroller_top_level is
    port(
        -- top_level clock interface
        top_clock_clk       : in std_logic;
	    top_clock_reset_n   : in std_logic;
	
	    -- top_level read master
	    top_avm_read_master_read            : out std_logic;
	    top_avm_read_master_address         : out std_logic_vector (31 downto 0);
	    top_avm_read_master_burstcount      : out std_logic_vector (10 downto 0);
	    top_avm_read_master_readdata        : in std_logic_vector (31 downto 0);
	    top_avm_read_master_readdatavalid   : in std_logic;
	    top_avm_read_master_waitrequest     : in std_logic;
	    top_avm_read_master_byteenable      : out std_logic_vector (3 downto 0);
	
	    -- top_level control & status registers (CSR) slave
	    top_avs_csr_address     : in std_logic_vector (2 downto 0);
	    top_avs_csr_read        : in std_logic;
	    top_avs_csr_readdata    : out std_logic_vector (31 downto 0);
	    top_avs_csr_write       : in std_logic;
	    top_avs_csr_writedata   : in std_logic_vector (31 downto 0);
	    top_avs_csr_CS          : in std_logic;

        -- top_level interface to LCD display
        top_conduit_RESET_n             : out   std_logic;
        top_conduit_CSX                 : out   std_logic;
        top_conduit_DCX                 : out   std_logic;
        top_conduit_WRX                 : out   std_logic;
        top_conduit_RDX                 : out   std_logic;
        top_conduit_Data_out            : out   std_logic_vector (15 downto 0)
    );
end LCD_Cotroller_top_level;


architecture rtl of LCD_Cotroller_top_level is
    -------------------------------------------------------------------------------
    -- Three custom IPs
    -- Image_burst_reader, connect with Avalon bus, read image data from memory
    -- fifo_test, synchronize data transfer between Image_burst_reader and LCD_Control
    -- LCD_Control, transfer image date to LCD display
    -------------------------------------------------------------------------------

    component Image_burst_reader is
        port (
            -- clock interface
            csi_clock_clk       : in std_logic;
            csi_clock_reset_n   : in std_logic;
        
            -- read master
            avm_read_master_read            : out std_logic;
            avm_read_master_address         : out std_logic_vector (31 downto 0);
            avm_read_master_burstcount      : out std_logic_vector (10 downto 0);
            avm_read_master_readdata        : in std_logic_vector (31 downto 0);
            avm_read_master_readdatavalid   : in std_logic;
            avm_read_master_waitrequest     : in std_logic;
            avm_read_master_byteenable      : out std_logic_vector (3 downto 0);
        
        
            -- control & status registers (CSR) slave
            avs_csr_address                 : in std_logic_vector (2 downto 0);
            avs_csr_read                    : in std_logic;
            avs_csr_readdata                : out std_logic_vector (31 downto 0);
            avs_csr_write                   : in std_logic;
            avs_csr_writedata               : in std_logic_vector (31 downto 0);
            avs_csr_CS                      : in std_logic;
    
    
            -- interface with fifo
            rgb_data        : out std_logic_vector (15 downto 0);
            write_fifo      : out std_logic;
            almost_full     : in std_logic;
    
    
            -- interface with LCD control
            command_acquisition     : out std_logic_vector (7 downto 0);
            new_mode                : out std_logic;
            mode_ack                : in std_logic;
            lcd_mode_select         : out std_logic_vector (2 downto 0)
        );
    end component Image_burst_reader;

    component fifo_test is
        port (
            aclr		: IN STD_LOGIC ;
            clock		: IN STD_LOGIC ;
            data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            rdreq		: IN STD_LOGIC ;
            wrreq		: IN STD_LOGIC ;
            almost_full	: OUT STD_LOGIC ;
            empty		: OUT STD_LOGIC ;
            full		: OUT STD_LOGIC ;
            q		    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    end component fifo_test;

    component LCD_Control is
        port (
          -- clock interface
          csi_clock_clk     : in std_logic;
          csi_clock_reset_n : in std_logic;
    
          -- interface with control & status registers (CSR) slave
          command_acquisition   : in    std_logic_vector (7 downto 0);
          new_mode              : in    std_logic;
          mode_ack              : out   std_logic;   
          LCD_Mode_select       : in    std_logic_vector (2 downto 0);
    
          -- interface with fifo
          FIFO_Empty          : in    std_logic;
          RdData              : in    std_logic_vector (15 downto 0);
          RdFIFO              : out   std_logic;
    
          -- interface with LCD display
          RESET_n             : out   std_logic;
          CSX                 : out   std_logic;
          DCX                 : out   std_logic;
          WRX                 : out   std_logic;
          RDX                 : out   std_logic;
          Data_out             : out   std_logic_vector (15 downto 0)
        );
    end component LCD_Control;

    -----------------------------------------------------------------------
    -- Connections between IPs
    -----------------------------------------------------------------------

    -- Connections between Image_burst_reader and fifo
	signal r_rgb_data           : std_logic_vector (15 downto 0);
	signal r_write_fifo_req     : std_logic;
	signal r_almost_full        : std_logic;

    -- Connections between Image_burst_reader with LCD_Control
    signal r_command_acquisition : std_logic_vector (7 downto 0);
	signal r_new_mode           : std_logic;
	signal r_mode_ack           : std_logic;
	signal r_LCD_Mode_select    : std_logic_vector (2 downto 0);

    -- Connections between LCD_Control and fifo
    signal r_FIFO_Empty          :  std_logic;
    signal r_RdData              :  std_logic_vector (15 downto 0);
    signal r_read_fifo_req       :  std_logic;

    -- Aclr signal for FIFO
    signal fifo_aclr            :  std_logic;


begin
    -- Instantiate Image_burst_reader
    Image_burst_reader_INST : Image_burst_reader
    port map(

        csi_clock_clk       => top_clock_clk,
	    csi_clock_reset_n   => top_clock_reset_n,
	
	    -- read master
	    avm_read_master_read            => top_avm_read_master_read,
	    avm_read_master_address         => top_avm_read_master_address,
	    avm_read_master_burstcount      => top_avm_read_master_burstcount,
	    avm_read_master_readdata        => top_avm_read_master_readdata,
	    avm_read_master_readdatavalid   => top_avm_read_master_readdatavalid,
	    avm_read_master_waitrequest     => top_avm_read_master_waitrequest,
	    avm_read_master_byteenable      => top_avm_read_master_byteenable,

	
	    -- control & status registers (CSR) slave
	    avs_csr_address     => top_avs_csr_address,
	    avs_csr_read        => top_avs_csr_read,
	    avs_csr_readdata    => top_avs_csr_readdata,
	    avs_csr_write       => top_avs_csr_write,
	    avs_csr_writedata   => top_avs_csr_writedata,
	    avs_csr_CS          => top_avs_csr_CS,


	    -- interface with fifo
	    rgb_data    => r_rgb_data,
	    write_fifo  => r_write_fifo_req,
	    almost_full => r_almost_full,


	    -- interface with LCD control
	    command_acquisition => r_command_acquisition,
	    new_mode            => r_new_mode,
	    mode_ack            => r_mode_ack,
	    lcd_mode_select     => r_LCD_Mode_select
    );

    -- Instantiate fifo
    fifo_test_INST : fifo_test
    port map (
        aclr		=>      fifo_aclr,  
        clock		=>      top_clock_clk,
        data		=>      r_rgb_data,
        rdreq		=>      r_read_fifo_req,
        wrreq		=>      r_write_fifo_req,
        almost_full	=>      r_almost_full,
        empty		=>      r_FIFO_Empty,
        full		=>      open,
        q		    =>      r_RdData
    );


    -- Instantiate LCD_Control
  LCD_Control_INST : LCD_Control
  port map(
    csi_clock_clk       => top_clock_clk,
    csi_clock_reset_n   => top_clock_reset_n,

    -- interface with Registers
    command_acquisition => r_command_acquisition,
    new_mode            => r_new_mode,
    mode_ack            => r_mode_ack,   
    LCD_Mode_select     => r_LCD_Mode_select,

    -- interface with FIFO
    FIFO_Empty          => r_FIFO_Empty,
    RdData              => r_RdData,
    RdFIFO              => r_read_fifo_req,

    -- interface with LCD display
    RESET_n             => top_conduit_RESET_n,
    CSX                 => top_conduit_CSX,
    DCX                 => top_conduit_DCX,
    WRX                 => top_conduit_WRX,
    RDX                 => top_conduit_RDX,
    Data_out            => top_conduit_Data_out
  );

  fifo_aclr            <= not top_clock_reset_n;
  
end;


