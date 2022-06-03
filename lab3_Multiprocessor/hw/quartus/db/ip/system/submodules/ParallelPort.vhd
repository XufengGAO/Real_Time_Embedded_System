library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ParallelPort with Interrupt
entity ParallelPort is

    -- configurable port width
    port (
        -- global signals
        Clk         : in    std_logic;
        nReset      : in    std_logic;

        -- interfacte to Avalon Bus
        Address     : in    std_logic_vector(2 downto 0);

        Read        : in    std_logic;
        ReadData    : out   std_logic_vector(7 downto 0);

        Write       : in    std_logic;
        WriteData   : in    std_logic_vector(7 downto 0);

        -- conduit interface
        ParPort     : inout std_logic_vector(7 downto 0);

        -- interrupr
        irq         : out   std_logic

    );
end ParallelPort;

architecture arcParport of ParallelPort is

    -- signal for register access
    signal iRegPort     : std_logic_vector(7 downto 0) := (others => '0');
    signal iRegDir      : std_logic_vector(7 downto 0) := (others => '0');
    signal iRegPin      : std_logic_vector(7 downto 0);

    -- signal to control interrupt
    signal iRegClrInt   : std_logic_vector(7 downto 0) := (others => '0');   -- clear interrup register
    signal iRegEnInt    : std_logic_vector(7 downto 0) := (others => '0');   -- enable interrupt register
    signal iOldRdData   : std_logic_vector(7 downto 0) := (others => '0');   -- store old iRegRdData value
    signal iRegInt      : std_logic_vector(7 downto 0) := (others => '0');   -- interrupt register
    signal iflag        : std_logic := '0'; 

begin

    -- output data to external ParPort
    pPort: process(iRegDir, iRegPort)
    begin
        for i in 0 to 7 loop
            if iRegDir(i) = '1' then
                ParPort(i) <= iRegPort(i);
            else 
                ParPort(i) <= 'Z';
            end if;
        end loop;
    end process pPort;

    -- external port value
    iRegPin <= ParPort;

    -- write data to registers
    pRegWr: process(Clk, nReset)
    begin
        if nReset = '0' then
            iRegPort    <= (others => '0');
            iRegDir     <= (others => '0');
            iRegEnInt   <= (others => '0');
            iRegClrInt  <= (others => '0');
        elsif rising_edge(Clk) then
            iRegClrInt <= (others => '0'); -- ClrInt as a pulse
            if Write = '1' then
                case Address is
                    when "000" => iRegDir   <= WriteData(7 downto 0);
                    when "010" => iRegPort  <= WriteData(7 downto 0);
                    when "011" => iRegPort  <= iRegPort or WriteData(7 downto 0); -- iRegSet
                    when "100" => iRegPort  <= iRegPort and not WriteData(7 downto 0); -- iRegClr
                    when "101" => iRegClrInt  <= WriteData(7 downto 0);
                    when "110" => iRegEnInt   <= WriteData(7 downto 0);
                    when "111" => iRegPort <= std_logic_vector(unsigned(iRegPort) + unsigned(WriteData(7 downto 0))); -- sp counter function
                    when others => null;
                end case;
            end if;
        end if;
    end process pRegWr;

    -- read data from registers
    pRegRd: process(Clk)
    begin
        if rising_edge(Clk) then
            ReadData <= (others => '0');
            if Read = '1' then
                case Address is
                    when "000" => ReadData(7 downto 0) <= iRegDir;
                    when "001" => ReadData(7 downto 0) <= iRegPin;
                    when "010" => ReadData(7 downto 0) <= iRegPort;
                    when "110" => ReadData(7 downto 0) <= iRegEnInt;
                    when "111" => ReadData(7 downto 0) <= iRegInt;
                    when others => null;
                end case;
            end if;
        end if;
    end process pRegRd;

    -- interrupt
    pInterrupt: process(Clk, nReset)
        variable varRdData : std_logic_vector(7 downto 0);
    begin
        if nReset = '0' then
            iOldRdData  <= (others => '0');
            iRegInt     <= (others => '0');
            iflag       <= '0';
        elsif rising_edge(Clk) then
            -- instant assignment
            if iflag = '0' then
                varRdData := iRegPin; -- 1st iRegPin
            else
                varRdData := iOldRdData; -- following iRegPin  (>1st)
            end if;
            --iRegInt <= iRegClrInt;
            iRegInt <= (iRegInt and not iRegClrInt) or (not varRdData and iRegPin);
            iOldRdData <= iRegPin;
            iflag <= '1';
        end if;
    end process pInterrupt;


    irq <= '0' when unsigned(iRegEnInt and iRegInt) = 0 else '1';
    --irq <= iRegInt(0);

end arcParport;