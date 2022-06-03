library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_multiply is
end tb_multiply;

architecture test of tb_multiply is

    constant CLK_PERIOD : time := 100 ns;

    signal sim_finished : boolean := false;

    signal clk : std_logic;
    signal nReset : std_logic;

    signal InputData : std_logic_vector(31 downto 0);
    signal result : unsigned(7 downto 0);
    signal result1 : unsigned(9 downto 0);
    signal result2 : unsigned(19 downto 0);
    signal result3 : unsigned(19 downto 0);
    signal result4 : unsigned(7 downto 0);
begin

    clk_generation : process
    begin
        if not sim_finished then
            clk <= '1';
            wait for CLK_PERIOD / 2;
            clk <= '0';
            wait for CLK_PERIOD / 2;
        else
            wait;
        end if;
    end process clk_generation;

    simulation : process

        procedure async_reset is 
        begin
            wait until rising_edge(CLK);
            wait for CLK_PERIOD / 4;
            nReset <= '0';

            wait for CLK_PERIOD / 2;
            nReset <= '1';
        end procedure async_reset;

    begin

        nReset <= '1';
        
        InputData <= "00000000" & "10101010" & "11110000" & "11001100";

        wait for CLK_PERIOD;
        async_reset;

        wait for 1000 ns;
        result1 <= unsigned("00" & InputData(23 downto 16)) + unsigned("00" & InputData(15 downto 8)) + unsigned("00" & InputData(7 downto 0));
        wait for 1000 ns;
        result2 <= result1 * 11;
        wait for 1000 ns;
        result3 <= shift_right(result2, 5);
        wait for 1000 ns;
        result4 <= result3(7 downto 0);

        result <= shift_right((unsigned("00" & InputData(23 downto 16)) + unsigned("00" & InputData(15 downto 8)) + unsigned("00" & InputData(7 downto 0))) * 11, 5)(7 downto 0); 
        
        sim_finished <= true;

        wait;

    end process simulation;


end architecture test;
