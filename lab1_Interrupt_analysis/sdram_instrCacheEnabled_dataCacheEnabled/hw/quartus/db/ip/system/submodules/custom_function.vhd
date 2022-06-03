library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CustomFunction is
    port(
        dataA   : in  std_logic_vector(31 downto 0);
        dataB   : in  std_logic_vector(31 downto 0);
        result  : out std_logic_vector(31 downto 0) 
    );
end CustomFunction;

architecture arcBitProcessing of CustomFunction is

begin
    result(7 downto 0)      <= dataA(31 downto 24);
    result(31 downto 24)    <= dataA(7 downto 0);

    -- for-loop
    --for index in 8 to 23 loop
        --result (31 - index) = dataA(index);
    --end loop;

    -- or brute force
    result(23) <= dataA(8);
    result(22) <= dataA(9);
    result(21) <= dataA(10);
    result(20) <= dataA(11);

    result(19) <= dataA(12);
    result(18) <= dataA(13);
    result(17) <= dataA(14);
    result(16) <= dataA(15);

    result(15) <= dataA(16);
    result(14) <= dataA(17);
    result(13) <= dataA(18);
    result(12) <= dataA(19);

    result(11) <= dataA(20);
    result(10) <= dataA(21);
    result(9)  <= dataA(22);
    result(8)  <= dataA(23);


end arcBitProcessing;
