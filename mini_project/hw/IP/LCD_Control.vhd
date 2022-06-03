library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity LCD_Control is

    port (
        -- global signals
        csi_clock_clk   : in std_logic;
        csi_clock_reset_n : in std_logic;

        -- interface to Image_burst_reader
        command_acquisition : in    std_logic_vector (7 downto 0);
        new_mode            : in    std_logic;
        mode_ack            : out   std_logic;   
        LCD_Mode_select     : in    std_logic_vector (2 downto 0);

        -- interface to FIFO
        FIFO_Empty          : in    std_logic;
        RdData              : in    std_logic_vector (15 downto 0);
        RdFIFO              : out   std_logic;

        -- interface to LCD display
        RESET_n             : out   std_logic;
        CSX                 : out   std_logic;
        DCX                 : out   std_logic;
        WRX                 : out   std_logic;
        RDX                 : out   std_logic;
        Data_out            : out std_logic_vector (15 downto 0)

    
    );
end LCD_Control;

architecture a of LCD_Control is 

        -- state machine states
        type operating_mode is (idle, accept_mode, writing_toLCD, ack_mode);
        signal LCD_state : operating_mode := idle;

        -- registers
        signal Current_Mode         : std_logic_vector (2 downto 0);
        signal Current_Command      : std_logic_vector (7 downto 0);
        signal rgb_register 		: std_logic_vector (15 downto 0);

        -- counter 
        signal WRX_counter              : integer range 0 to 20 := 0;
        signal flag_counter_signal      : integer range 0 to 80000 := 0;

        -- signal to FIFO
        signal RdFIFO_flag      : std_logic := '0';
        signal RdFIFO_sig       : std_logic := '0';

begin

    p_LOAD_NEW_MODE: process(csi_clock_clk, csi_clock_reset_n)
    begin
        if csi_clock_reset_n = '0' then
            -- reset registers
            Current_Mode <= (others => '0');
            Current_Command <= (others => '0');
            rgb_register <= (others => '0');

            -- reset interface to Registers
            mode_ack <= '0';

            -- reset interface to FIFO
            RdFIFO_sig <= '0';

            -- reset interface to LCD display
            RESET_n <= '1';
            CSX <= '1';
            DCX <= '0';
            WRX <= '1';
            RDX <= '1';
            Data_out <= (others => '0');
            -- reset counter
            WRX_counter <= 0;
            
            -- initialize state machine 
            LCD_state <= idle;

        elsif rising_edge (csi_clock_clk) then

            case LCD_state is

                -- IDLE
			    -- When idle just sit and wait for the new_mode signal.
			    -- Start the machine by moving to the accept_command state and initialising registers and output pins.
                when idle =>
                    -- Set chip-select, disable LCD display
                    CSX <= '1';
                    
                    if new_mode = '1' then
                        -- get mode and command value
                        Current_Mode <= LCD_Mode_select;
                        Current_Command <= command_acquisition;

                        -- initialize output pin signals
                        DCX <= '0';
                        WRX <= '1';
                        RDX <= '1';

                        -- initialize counter
                        WRX_counter <= 0;

                        -- clear chip-select, enable LCD display
                        CSX <= '0';
                        RdFIFO_sig <= '0';

                        -- goto accept_mode state 
                        LCD_state <= accept_mode;

                    end if;

                when accept_mode =>

                    -- check the mode code
                    case Current_Mode is

                        -- Set RESET_n
                        when "000" =>
                            RESET_n <= '1';
                            mode_ack <= '1';
                            LCD_state <= ack_mode;
    
                        -- Clear RESET_n
                        when "001" =>
                            RESET_n <= '0';
                            mode_ack <= '1';
                            LCD_state <= ack_mode;
                
                        -- Fetch command address to data_out
                        -- Clear DCX, and produce WRX
                        when "010" =>
                            Data_out <= "00000000" & Current_Command;
                            DCX <= '0';
                            WRX <= '0';
                            
                            -- goto writing_toLCD state 
                            LCD_state <= writing_toLCD;
                        
                        -- Fetch command data to data_out
                        -- Set DCX, and produce WRX
                        when "011" =>
                            Data_out <= "00000000" &  Current_Command;
                            DCX <= '1';
                            WRX <= '0';

                            -- goto writing_toLCD state 
                            LCD_state <= writing_toLCD;

                        -- Fetch image data from RdData to Data_out
                        -- Set D/CX, and produce WRX
                        when "100" =>
                            -- wait until the fifo has enough words
                            if FIFO_Empty = '0' then
                                -- goto writing_toLCD state 
                                LCD_state <= writing_toLCD;
                                WRX_counter <= 0;

                                DCX <= '1';
                                WRX <= '0';

                                -- assert read request signal
                                RdFIFO_sig <= '1';
                            end if;
                            
                        when others =>
                            -- do nothing
                            -- go back to idle state 
                            LCD_state <= idle;
    
                    end case;

                when writing_toLCD =>

                    -- store image data 
                    if WRX_counter = 1 then
                        rgb_register <= RdData;
                    end if;

                    WRX_counter <= WRX_counter + 1;

                    -- deassert read request signal
                    RdFIFO_sig <= '0';

                    -- output image data to Data_out
                    if WRX_counter = 2 and Current_Mode = "100"  then
                        Data_out <= rgb_register;
                    end if;

                    -- toggle WRX
                    if WRX_counter = 4 then
                        if Current_Mode = "100" then
                            -- toggle WRX to high
                            if RdFIFO_flag ='1' then
                                WRX <= '1';
                            else
                                -- restart writing_toLCD
                                WRX_counter <= 0;
                                LCD_state <= writing_toLCD;
                                RdFIFO_sig <= '1';
                                WRX <= '0';
                            end if;
                        end if;

                        if Current_Mode = "010" or Current_Mode = "011" then
                            WRX <= '1';
                        end if;
                    end if;

                    -- WRX finished
                    if WRX_counter = 8 then

                        if Current_Mode = "100" then
                            -- all pixels have been written to LCD
                            if flag_counter_signal = 76800 then
                                mode_ack <= '1';
                                RdFIFO_sig <= '0';
                                LCD_state <= ack_mode;
                                WRX_counter <= 0;
                            else
                                -- check the state of FIFO
                                if FIFO_Empty = '0' then
                                    WRX_counter <= 0;
                                    LCD_state <= writing_toLCD;
                                    RdFIFO_sig <= '1';
                                    WRX <= '0';
                                else
                                    -- if FIFO is empty, go back to accept_mode
                                    LCD_state <= accept_mode;
                                    WRX_counter <= 0;
                                    RdFIFO_sig <= '0';
                                end if;
                            end if;
                        end if;

                        if Current_Mode = "010" or Current_Mode = "011" then
                            mode_ack <= '1';
                            LCD_state <= ack_mode;
                            WRX_counter <= 0;
                        end if;

                    end if;
        

                when ack_mode =>
                    if new_mode = '0' then
                        LCD_state <= idle;
                        mode_ack <= '0';
                    end if;
            end case;

            
        end if;
    
    end process;


    p_Check_RdFIFO : process(csi_clock_clk)
    begin
        if rising_edge(csi_clock_clk) then
            -- reset flag_counter_signal
            if LCD_state = idle then
                flag_counter_signal <= 0;
            end if;

            -- count the number of pixels that have been written to LCD 
            if RdFIFO_sig ='1' then
                RdFIFO_flag <= '1';
                flag_counter_signal <= flag_counter_signal + 1;
            end if;

            -- reset flage4
            if WRX_counter = 7 then
                RdFIFO_flag <='0';
            end if;
        end if;
    end process;

    -- read request signal to FIFO
    RdFIFO <= RdFIFO_sig;
end a;









