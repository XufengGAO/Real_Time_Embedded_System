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

    signal input1 : unsigned(7 downto 0);
    signal input2 : unsigned(7 downto 0);
    signal input3 : unsigned(7 downto 0);
    signal input4 : unsigned(7 downto 0);
    signal input5 : unsigned(7 downto 0);
    signal input6 : unsigned(7 downto 0);

    signal result : signed(11 downto 0);
    signal result_bin : std_logic;
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
        
        input1 <= "00001111";
        input2 <= "00001000";
        input3 <= "00001000";
        input4 <= "10000000";
        input5 <= "00001100";
        input6 <= "00001111";

        wait for CLK_PERIOD;
        async_reset;

        wait for 1000 ns;
        --result <= signed("0000" & input4) + shift_left(signed("0000" & input5),1) + signed("0000" & input6) - signed("0000" & input1) - shift_left(signed("0000" & input2),1) - signed("0000" & input3);
        wait for CLK_PERIOD;
        result <= abs(signed("0000" & input4) + shift_left(signed("0000" & input5),1) + signed("0000" & input6) - signed("0000" & input1) - shift_left(signed("0000" & input2),1) - signed("0000" & input3));
        wait for CLK_PERIOD;
        if result > 400 then
            result_bin <= '1';
        else
            result_bin <= '0';
        end if;

        sim_finished <= true;

        wait;

    end process simulation;


end architecture test;
