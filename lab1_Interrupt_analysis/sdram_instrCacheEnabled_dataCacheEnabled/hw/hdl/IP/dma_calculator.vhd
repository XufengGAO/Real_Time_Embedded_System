library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dma_calculator is
port (
	-- clock interface
	csi_clock_clk : in std_logic;
	csi_clock_reset_n : in std_logic;
	
	-- master part
	avm_master_address : out std_logic_vector (31 downto 0);
	avm_master_byteenable : out std_logic_vector (3 downto 0);
	avm_master_write : out std_logic;
	avm_master_read : out std_logic;
	avm_master_writedata : out std_logic_vector (31 downto 0);
	avm_master_readdata : in std_logic_vector (31 downto 0);
	avm_master_waitrequest : in std_logic;
	
	-- control & status registers (CSR) slave
	avs_csr_address : in std_logic_vector (2 downto 0);
	avs_csr_read : in std_logic;
	avs_csr_readdata : out std_logic_vector (31 downto 0);
	avs_csr_write : in std_logic;
	avs_csr_writedata : in std_logic_vector (31 downto 0)
);
end dma_calculator;

architecture behv of dma_calculator is

-- state machine states
type states is (Idle, LoadPara, SendReadReq, WaitForRead, Compute, SendWriteReq, WaitForWrite);
signal state : states := Idle;

-- register in Avalon Slave
-- 000 - RegReadAddr
-- 001 - RegWriteAddr
-- 010 - RegComputeCount
-- 011 - RegStart
-- 100 - RegDone

signal RegReadAddr : std_logic_vector (31 downto 0);	-- read start address for master
signal RegWriteAddr : std_logic_vector (31 downto 0);	-- write start address for master
signal RegComputeCount : std_logic_vector (31 downto 0);	-- total number of computation needed
signal RegStart : std_logic;	-- start signal to control
signal RegDone : std_logic;		-- flag to indicate finish or not

-- inside register to store values
signal CurrentReadAddr : unsigned (31 downto 0);	-- current read address
signal CurrentWriteAddr : unsigned (31 downto 0);	-- current write address
signal CurrentCount : unsigned (31 downto 0);	-- current remain number to compute

signal CurrentData : std_logic_vector (31 downto 0);	-- current data read from memory
signal ComputeResult : std_logic_vector (31 downto 0);	-- result of computation

begin

-- Avalon slave writes parameters
AvalonSlaveWr : process(csi_clock_clk, csi_clock_reset_n)
begin
	if csi_clock_reset_n = '0' then
		RegReadAddr <= (others => '0');
		RegWriteAddr <= (others => '0');
		RegComputeCount <= (others => '0');
		RegStart <= '0';
	elsif rising_edge(csi_clock_clk) then
		RegStart <= '0';
		if avs_csr_write = '1' then
			case avs_csr_address is
				when "000" =>	RegReadAddr <= avs_csr_writedata;
				when "001" =>	RegWriteAddr <= avs_csr_writedata;
				when "010" =>	RegComputeCount <= avs_csr_writedata;
				when "011" =>	RegStart <= avs_csr_writedata(0);
				when others =>	null;
			end case;
		end if;
	end if;

end process AvalonSlaveWr;


-- Avalon slave read state (done or not)
AvalonSlaveRd : process(csi_clock_clk)
begin
	if rising_edge(csi_clock_clk) then
		if avs_csr_read = '1' then
			case avs_csr_address is 
				when "100" =>	avs_csr_readdata <= "0000000000000000000000000000000" & RegDone;
				when others =>	null;
			end case;
		end if;
	end if;
end process AvalonSlaveRd;


-- Avalon master read, compute, and Avalon write
AvalonMasterAndCompute : process(csi_clock_clk, csi_clock_reset_n)
begin
	if csi_clock_reset_n = '0' then
		state <= Idle;
		CurrentReadAddr <= (others => '0');
		CurrentWriteAddr <= (others => '0');
		CurrentCount <= (others => '0');
		CurrentData <= (others => '0');
		ComputeResult <= (others => '0');

	elsif rising_edge(csi_clock_clk) then
		case state is
			when Idle => -- wait for start
				avm_master_read <= '0';
				avm_master_write <= '0';
				avm_master_writedata <= (others => '0');
				avm_master_address <= (others => '0');
				avm_master_byteenable <= (others => '0');
				if RegStart = '1' then
					state <= LoadPara;
					RegDone <= '0'; -- clear the Done flag
				end if;

			when LoadPara => -- load all parameters for master and computing
				CurrentReadAddr <= unsigned(RegReadAddr);
				CurrentWriteAddr <= unsigned(RegWriteAddr);
				CurrentCount <= unsigned(RegComputeCount);
				state <= SendReadReq;
			
			when SendReadReq => -- start to read from memory
				avm_master_write <= '0';
				avm_master_address <= std_logic_vector(CurrentReadAddr);
				avm_master_byteenable <= "1111";
				avm_master_read <= '1';
				state <= WaitForRead;

			when WaitForRead => -- wait for valid read data
				if avm_master_waitrequest = '0' then 
					CurrentData <= avm_master_readdata;
					avm_master_read <= '0';
					state <= Compute;
				end if;

			when Compute => -- do computation (swap)
				ComputeResult(7 downto 0) <= CurrentData(31 downto 24);
				ComputeResult(31 downto 24) <= CurrentData(7 downto 0);
				ComputeResult(23) <= CurrentData(8);
				ComputeResult(22) <= CurrentData(9);
				ComputeResult(21) <= CurrentData(10);
				ComputeResult(20) <= CurrentData(11);
				ComputeResult(19) <= CurrentData(12);
				ComputeResult(18) <= CurrentData(13);
				ComputeResult(17) <= CurrentData(14);
				ComputeResult(16) <= CurrentData(15);
				ComputeResult(15) <= CurrentData(16);
				ComputeResult(14) <= CurrentData(17);
				ComputeResult(13) <= CurrentData(18);
				ComputeResult(12) <= CurrentData(19);
				ComputeResult(11) <= CurrentData(20);
				ComputeResult(10) <= CurrentData(21);
				ComputeResult(9) <= CurrentData(22);
				ComputeResult(8) <= CurrentData(23);
				state <= SendWriteReq;

			when SendWriteReq => -- write the result by avalon master
				avm_master_read <= '0';
				avm_master_address <= std_logic_vector(CurrentWriteAddr);
				avm_master_byteenable <= "1111";
				avm_master_writedata <= ComputeResult;
				avm_master_write <= '1';
				state <= WaitForWrite;

				CurrentCount <= CurrentCount - 1;
			
			when WaitForWrite => -- wait for write to complete
				if avm_master_waitrequest = '0' then 
					avm_master_write <= '0';
					
					if CurrentCount > 0 then
						-- have more data to compute
						CurrentReadAddr <= CurrentReadAddr + 4;
						CurrentWriteAddr <= CurrentWriteAddr + 4;
						state <= SendReadReq;
					else 
						-- finish all data, set the Done flag
						RegDone <= '1';
						state <= Idle;
					end if;
				end if;
				
		end case;
	end if;
		
end process AvalonMasterAndCompute;


end behv;

