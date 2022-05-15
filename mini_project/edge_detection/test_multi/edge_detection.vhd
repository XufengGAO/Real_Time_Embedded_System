library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity edge_detection is
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
end edge_detection;

architecture behv of edge_detection is

-- state machine states
type states is (Idle, NewRow, Compute, ToFIFO, Branch, NewCol, Done);
signal state : states := Idle;

-- state machine to control avalon slave register 
type send_commands_states_T is (idle, wait_ack);
signal send_state : send_commands_states_T := idle;

-- CSR registers
signal csr_Mode_select 		: std_logic_vector (31 downto 0);	-- the mode of the system
signal csr_LCD_command_data : std_logic_vector (31 downto 0);	-- the command address and data for configuration
signal csr_Read_address 	: std_logic_vector (31 downto 0);	-- the start read address of master
signal csr_Status 			: std_logic_vector (31 downto 0);	-- the status, CPU can poll it
signal csr_Start_flag 		: std_logic_vector (31 downto 0);	-- start flag for DMA
signal new_mode_reg 		: std_logic;						-- indicate new mod

-- inside register to store values
signal CurrentReadAddr : std_logic_vector (31 downto 0);	-- current read address
signal CurrentRowCount : integer;	-- current remain number to compute
signal CurrentColCount : integer;	-- current remain number to compute

-- 

signal write_flag			: std_logic := '0';					-- flag to control write request to FIFO
signal rgb_register 		: std_logic_vector (15 downto 0);	-- register to store image data

-- data matrix
signal data1 : unsigned(7 downto 0) := (others => '0');
signal data2 : unsigned(7 downto 0) := (others => '0');
signal data3 : unsigned(7 downto 0) := (others => '0');
signal data4 : unsigned(7 downto 0) := (others => '0');
signal data5 : unsigned(7 downto 0) := (others => '0');
signal data6 : unsigned(7 downto 0) := (others => '0');
signal data7 : unsigned(7 downto 0) := (others => '0');
signal data8 : unsigned(7 downto 0) := (others => '0');
signal data9 : unsigned(7 downto 0) := (others => '0');



-- counter for read 9 pixels in NewRow
signal PixelCounter : integer range 0 to 8 := 0;

-- counter for shift pixels
signal ShiftCounter : integer range 0 to 5 := 0;

begin

EdgeDetecting: process (csi_clock_clk, csi_clock_reset_n)

variable summax, summay : signed(10 downto 0); -- only convolution
variable summa1, summa2 : signed(10 downto 0); -- after absolute
variable summa : signed(10 downto 0);			 -- final result

begin
	if csi_clock_reset_n = '0' then
		state <= Idle;
		CurrentReadAddr <= (others => '0');
		CurrentRowCount <= 0;
		CurrentColCount <= 0;
		PixelCounter <= 0;

	elsif rising_edge (csi_clock_clk) then
		case state is
			-- IDLE
			-- When idle just sit and wait for the Start flag.
			-- Start the machine by moving to the NewRow state and initialising address and counters.
			when Idle =>
				avm_read_master_read <= '0';
				write_flag <= '0';
				if csr_Start_flag(0) = '1' then
					CurrentRowCount <= 1;
					CurrentColCount <= 1;
					CurrentReadAddr <= csr_Read_address;
					PixelCounter <= 0;


					write_flag <= '0';
					avm_read_master_address <= CurrentReadAddr;
	
					-- check that fifo has enough space for at least one pixel
					-- If so, start a NewRow.
					if FIFO_full = '0' then
						avm_read_master_read <= '1';				-- assert master read signal to Avalon
						state <= NewRow;
					end if;	

				end if;

			-- NewRow
			-- 9 iterations, 
			when NewRow =>
				-- read current avalon_read_data & 32-bits RGB to 8-bits gray
				-- dertermine pixel index
				-- unsigned to unsigned
				if avm_read_master_waitrequest = '0' then 
				    avm_read_master_read <= '0';

					case PixelCounter is
						when 0 => 
							data1 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(0) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr + 968;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';
						when 1 => 
							data2 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(1) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr + 968;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';
						when 2 => 
							data3 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(2) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr - 1932;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';						
						when 3 => 
							data4 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(3) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr + 968;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';
						when 4 => 
							data5 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(4) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr + 968;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';	
						when 5 => 
							data6 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(5) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr - 1932;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';		
						when 6 => 
							data7 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(6) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr + 968;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';	
						when 7 => 
							data8 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(7) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr + 968;
							PixelCounter <= PixelCounter + 1;
							avm_read_master_read <= '1';
						when 8 => 
							data9 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							--pixel_memory(8) <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
							
							CurrentReadAddr <= CurrentReadAddr - 1932;
							PixelCounter <= 0;
							state <= Compute;
					end case;
				end if;

			when Compute =>

				-- do the convolution, unsigned data to signed result
				-- compare the threshold value (may change by software)
				-- above the threshold: white, below the thrshold: black
				-- rgb_register
				-- abs(y + x)
				

				-- summa:= summa1 + summa2;
				--summa1 := abs(signed("000" & data7) + shift_left(signed("000" & data8),1) + signed("000" & data9) - signed("000" & data1) - shift_left(signed("000" & data2),1) - signed("000" & data3));
				--summa2 := abs(signed("000" & data3) + shift_left(signed("000" & data6),1) + signed("000" & data9) - signed("000" & data1) - shift_left(signed("000" & data4),1) - signed("000" & data7));
				summa:= abs(signed("000" & data7) + shift_left(signed("000" & data8),1) + signed("000" & data9) - signed("000" & data1) - shift_left(signed("000" & data2),1) - signed("000" & data3))
						 + abs(signed("000" & data3) + shift_left(signed("000" & data6),1) + signed("000" & data9) - signed("000" & data1) - shift_left(signed("000" & data4),1) - signed("000" & data7));
				

				if summa > 127 then
					rgb_register <= (others => '1');
				else
				    rgb_register <= (others => '0');
				end if;

				state <= ToFIFO;

			when ToFIFO =>
				-- flag to assert FIFO write request signal
				rgb_data <= rgb_register;
				write_fifo <= '1';		-- write request to FIFO
				-- counter increment
				 
				CurrentColCount <= CurrentColCount + 1;
				state <= Branch;

			when Branch =>
			    write_fifo <= '0';
				if CurrentColCount = 240 and CurrentRowCount = 319 then
					state <= Done;
				elsif CurrentColCount = 240 then
					if FIFO_full = '0' then
						CurrentRowCount <= CurrentRowCount + 1;
						CurrentColCount <= 0;
						state <= NewRow;
						avm_read_master_read <= '1';
						-- address update or not
					end if;
				else
					if FIFO_full = '0' then
						state <= NewCol;
						ShiftCounter <= 0;
					end if;
				end if;

			when NewCol =>
				case ShiftCounter is
					when 0 =>
						data1 <= data4;
						data2 <= data5;
						data3 <= data6;
						ShiftCounter <= ShiftCounter + 1;
					when 1 => 
						data4 <= data7;
						data5 <= data8;
						data6 <= data9;
						ShiftCounter <= ShiftCounter + 1;
						avm_read_master_read <= '1';
						PixelCounter <= 0;
					when 2 =>
						if avm_read_master_waitrequest = '0' then 
				    		avm_read_master_read <= '0';

							case PixelCounter is
								when 0 => 
									data7 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
									CurrentReadAddr <= CurrentReadAddr + 968;
									PixelCounter <= PixelCounter + 1;
									avm_read_master_read <= '1';
								when 1 => 
									data8 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
									CurrentReadAddr <= CurrentReadAddr + 968;
									PixelCounter <= PixelCounter + 1;
									avm_read_master_read <= '1';
								when 2 => 
									data9 <= shift_right((unsigned("00" & avm_read_master_readdata(23 downto 16)) + unsigned("00" & avm_read_master_readdata(15 downto 8)) + unsigned("00" & avm_read_master_readdata(7 downto 0))) * 11, 5)(7 downto 0);
									CurrentReadAddr <= CurrentReadAddr - 1932;
									PixelCounter <= 0;
									state <= Compute;	
								when others =>				
							end case;
						end if;
					when others =>
				end case;

			when Done =>
				--if csr_Status(0) = '1' then
				state <= Idle;
				--end if;
				
		end case;

	end if;
end process;

-- enable all byteenable bits
avm_read_master_byteenable <= "1111";


-------------------------------------------------------------------------------
-- CONTROL AND STATUS REGISTERS
-------------------------------------------------------------------------------

-- control and status registers
--
-- address map
--  000 csr_Mode_select			0x00
--  001 csr_LCD_command_data	0x04
--  010 csr_Read_address		0x08
--  011 csr_Burst_count			0x0C
--  100 csr_Burst_total			0X10
--  101 csr_Status (read only)	0X14
--  110 csr_Start_flag			0X18
--
-- state machine states


-- write control of read and write address registers
csr: process (csi_clock_clk, csi_clock_reset_n)
begin
	if csi_clock_reset_n = '0' then
		csr_Mode_select <= (others => '0');
		csr_Read_address <= (others => '0');
		send_state <= idle;
	elsif rising_edge (csi_clock_clk) then
		-- write in slave
		if send_state = idle then
			if avs_csr_write = '1' then
				case avs_csr_address is

					-- select mode, send mode to LCD_Control
					-- change state to wait_ack
					-- In C, we use IOWR to clear csr_Status = 0
					when "000" =>
						csr_Mode_select <= avs_csr_writedata;
						new_mode_reg <= '1';
						send_state <= wait_ack;

					-- load LCD command data and command address
					when "001" =>
						csr_LCD_command_data <= avs_csr_writedata;

					-- load DMA's memory reading address
					when "010" =>
						csr_Read_address <= avs_csr_writedata;

					-- reset csr_Status
					when "101" =>
						csr_Status <= avs_csr_writedata;
						
					-- start DMA
					when "110" =>
						csr_Start_flag <= avs_csr_writedata;

					when others =>
				end case;
			end if;
		else
			if csr_Mode_select(2 downto 0) = "100" then
				csr_Start_flag <= X"00000000";	-- clear start flag 
			end if;

			if mode_ack = '1' then
				new_mode_reg <= '0';
			end if;

			-- process finished, csr_Status = '1'
			if new_mode_reg = '0' and mode_ack = '0' then
				send_state <= idle;
				csr_Status <= X"00000001";
			end if;
		end if;
		
		-- read in slave
		if avs_csr_read = '1' then
			if avs_csr_address = "101" then
				avs_csr_readdata <= csr_Status;
			end if;
		end if;

	end if;

end process;		


-- interface with LCD Control
command_acquisition <= csr_LCD_command_data(7 downto 0);
lcd_mode_select <= csr_Mode_select(2 downto 0);

new_mode <= new_mode_reg;

end behv;

