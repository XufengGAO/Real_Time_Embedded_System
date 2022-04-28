library ieee;
use ieee.std_logic_1164.aLL;
use ieee.numeric_std.all;

entity Counter is

    generic (countWidth: integer := 32);
    port (
        -- global signals
        Clk         : in    std_logic;
        nReset      : in    std_logic;

        -- interface to Avalon Bus
        ReadData    : out   std_logic_vector(countWidth-1 downto 0);
        WriteData   : in    std_logic_vector(countWidth-1 downto 0);

        Address     : in    std_logic_vector(1 downto 0);

        Read        : in    std_logic;
        Write       : in    std_logic
    );
end Counter;

architecture arcCounter of Counter is

    -- signals for register access
    signal iRegReset    :   std_logic;  -- reset
    signal iRegStart    :   std_logic;  -- start
    signal icounter      :   unsigned(countWidth-1 downto 0) := (others => '0'); -- counter
begin

    -- write data to registers
    WriteToCounter: process(Clk, nReset)
    begin
        if nReset = '0' then
            iRegReset   <= '0';
            iRegStart   <= '0';
        elsif rising_edge(Clk) then
            iRegReset <= '0';
            if Write = '1' then
                case Address(1 downto 0) is
                    when "00" => iRegReset <= '1';
                    when "01" => iRegStart <= '1';
                    when "10" => iRegStart <= '0';
                    when others => null;
                end case;
            end if;
        end if;
    end process WriteToCounter;

    -- counting process
    Counting: process(Clk, nReset)
    begin
        if rising_edge(Clk) then
            if  iRegReset = '1' then
                icounter <= (others => '0');
            elsif iRegStart = '1' then
                icounter <= icounter + 1;
            end if;
        end if;
    end process Counting;
    
    -- Read counter value
    ReadCounter: process(Clk)
    begin
        if rising_edge(Clk) then
            ReadData <= (others => '0');
            if Read = '1' then
                case Address(1 downto 0) is 
                    when "11" => ReadData <= std_logic_vector(icounter);
                    when others => null;
                end case;
            end if;
        end if;
    end process ReadCounter;

end arcCounter;












