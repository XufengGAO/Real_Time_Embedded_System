library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitManipulate is
    port(
        dataA   : in  std_logic_vector(31 downto 0);
        dataB   : in  std_logic_vector(31 downto 0);
        result  : out std_logic_vector(31 downto 0) 
    );
end BitManipulate;

architecture archi of BitManipulate is
    begin
        -- BitSwap
        result(7 downto 0) <= dataA(31 downto 24);
        result(31 downto 24) <= dataA(7 downto 0);
    
        -- BitFlip
        BitFlip: for i in 0 to 15 generate
            result (8+i) <= dataA(23-i);
        end generate BitFlip;
end archi;