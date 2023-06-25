library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity counter_8bit is
    port ( counter_8bit_rst_n, counter_8bit_clk, counter_8bit_en : in std_logic;
         counter_8bit_out: out std_logic_vector(7 downto 0));
end counter_8bit;

architecture BEHAVIORAL of counter_8bit is

    signal count : std_logic_vector(7 downto 0);
begin

    process(counter_8bit_rst_n,counter_8bit_clk)
    begin
        if (counter_8bit_rst_n = '0') then
            count <= "00000000";
        elsif (counter_8bit_clk'event and counter_8bit_clk = '1') then
            if (counter_8bit_en='1') then
                count <= count + 1;
            end if;
        end if;
    end process;

    counter_8bit_out <= count;
end BEHAVIORAL;