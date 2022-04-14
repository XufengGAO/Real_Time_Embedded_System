library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- testbench for parallel port with interrupt
entity tb_ParallelPort is
begin
end tb_ParallelPort;

architecture test of tb_ParallelPort is

    constant CLK_PERIOD : time := 20 ns;
    signal test_finished : boolean := false;

    -- avalon
    signal  Clk         :   std_logic;
    signal  nReset      :   std_logic;
    signal  Address     :   std_logic_vector(2 downto 0);
    signal  Read        :   std_logic;
    signal  ReadData    :   std_logic_vector(7 downto 0);
    signal  Write       :   std_logic;
    signal  WriteData   :   std_logic_vector(7 downto 0);
    signal  ParPort     :   std_logic_vector(7 downto 0);
    signal  irq         :   std_logic;


begin

    dut : entity work.ParallelPort
    port map(
        Clk => Clk,
        nReset => nReset,
        ReadData => ReadData,
        WriteData => WriteData,
        Address => Address,
        Read => Read,
        Write => Write,
        ParPort => ParPort,
        irq => irq
    );

    -- clock
    clk_generation: process
    begin
        if not test_finished then
            Clk <= '1';
            wait for CLK_PERIOD / 2;
            Clk <= '0';
            wait for CLK_PERIOD / 2;
        else
            wait;
        end if;
    end process clk_generation;

    -- test
    simulation: process

        procedure async_reset is
        begin
            wait until rising_edge(Clk);
            wait for CLK_PERIOD / 4;
            nReset <= '0';
            wait for CLK_PERIOD / 2;
            nReset <= '1';
        end procedure async_reset;

        procedure avalonWR(addr: in std_logic_vector(2 downto 0);
                           data: in std_logic_vector(7 downto 0)) is
        begin
            Write <= '1';
            Read <= '0';
            WriteData <= data;
            Address <= addr;
            wait until rising_edge(Clk); -- avalon already catched
            wait for CLK_PERIOD / 8;
            Write <= '0';
        end procedure avalonWR;

        procedure check_res(addr: in std_logic_vector(2 downto 0);
                            res_read: in std_logic_vector(7 downto 0);
                            res_expected: in std_logic_vector(7 downto 0)) is
        begin
            assert res_read = res_expected
            report "Unexpected result: " &
                    "addr = " & integer'image(to_integer(unsigned(addr))) & "; " &
                    "read = " & integer'image(to_integer(unsigned(res_read))) & "; " &
                    "exp = " & integer'image(to_integer(unsigned(res_expected)))
            severity error;
        end procedure check_res;

        procedure avalonRD(addr: in std_logic_vector(2 downto 0);
                           res_expected: in std_logic_vector(7 downto 0)) is
        begin
            Write <= '0';
            Read <= '1';
            Address <= addr;
            wait until rising_edge(Clk);
            -- 1 wait
            wait until rising_edge(Clk);
            wait for CLK_PERIOD / 8;
            check_res(addr, ReadData, res_expected);
            Read <= '0';
        end procedure avalonRD;

        variable test: std_logic_vector(7 downto 0);


    begin
        -- initialization
        nReset <= '1';
        address <= (others => '0');
        writedata <= (others => '0');
        write <= '0';
        read <= '0';
        wait for CLK_PERIOD;
        -- reset
        async_reset;
        wait for CLK_PERIOD/2;

        -- test iRegDir
        avalonWR("010", X"FF"); -- iRegPort = X"FF"
        test := (others => '0');
        avalonWR("000", test); -- write iRegDir(7:0) = '1'
        avalonRD("000", test); -- read iRegDir

        test := (others => '0');
        avalonRD("001", X"FF"); -- read iRegPin
        check_res("001", ParPort, test); -- check ParPort
 
        -- test iRegClr
        -- current output b"11111111"
        avalonWR("100", X"FF"); -- clr all bits

        test := (others => '0');
        avalonRD("010", test); -- read iRegPort
        avalonRD("001", test); -- read iRegPin
        check_res("100", ParPort, test); -- check ParPort

        -- test iRegSet
        -- current output b"00000000"
        test := (others => '0');
        test(2 downto 0) := b"111";
        avalonWR("011", test); -- set bits(2:0)

        test := (others => '0');
        test(2 downto 0) := b"111";
        avalonRD("010", test); -- read iRegPort
        avalonRD("001", test); -- read iRegPin
        check_res("011", ParPort, test); -- check ParPort

        -----------------------------------------------------------

        -- test iRegClrInt and iRegInt registers
        avalonWR("000", X"FF"); -- output mode
        avalonWR("010", X"00"); -- output all 0s
        avalonWR("101", X"FF"); -- clear all interrups
        avalonWR("110", X"01"); -- enable interrupt at Parport(0)
        --avalonRD("110", X"01"); -- read iRegInt

        -- 1st irq
        -- set Parport(0)
        test := (others => '0');
        test(0) := '1';
        avalonWR("011", test);

        --wait for CLK_PERIOD;
        --assert irq = '1' report "IRQ is on" severity error;

        -- read iRegInt
        --wait until rising_edge(Clk);
        --wait for CLK_PERIOD / 8;
        --avalonRD("111", X"01");

        -- clear Parport(0)
        avalonWR("100", X"FF");

        -- clear 1st irq
        test := (others => '0');
        test(0) := '1';
        avalonWR("101", test);

        --wait for CLK_PERIOD;
        --assert irq = '0' report "IRQ sbould be off" severity error;

        -- 2nd irq
        -- set Parport(0)
        test := (others => '0');
        test(0) := '1';
        avalonWR("011", test);

        --wait for CLK_PERIOD;
        --assert irq = '1' report "IRQ sbould be on" severity error;

        -- read iRegInt
        --wait until rising_edge(Clk);
        --wait for CLK_PERIOD / 8;
        --avalonRD("111", X"01");

        -- clear Parport(0)
        avalonWR("100", X"FF");

        -- clear 2nd irq
        test := (others => '0');
        test(0) := '1';
        avalonWR("101", test);

        --wait for CLK_PERIOD;
        --assert irq = '0' report "IRQ sbould be off" severity error;

        --check_avalon;
        wait for CLK_PERIOD * 5;
        test_finished <= true;

    end process simulation;



end architecture test;















