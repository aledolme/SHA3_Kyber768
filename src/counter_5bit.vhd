library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity counter_5bit is
    port ( counter_5bit_rst_n, counter_5bit_clk, counter_5bit_en : in std_logic;
         counter_5bit_out: out std_logic_vector(4 downto 0));
end counter_5bit;

architecture BEHAVIORAL of counter_5bit is

    signal count : std_logic_vector(4 downto 0);
begin

    process(counter_5bit_rst_n,counter_5bit_clk)
    begin
        if (counter_5bit_rst_n = '0') then
            count <= "00000";
        elsif (counter_5bit_clk'event and counter_5bit_clk = '1') then
            if (counter_5bit_en='1') then
                count <= count + 1;
            end if;
        end if;
    end process;

    counter_5bit_out <= count;
end BEHAVIORAL;