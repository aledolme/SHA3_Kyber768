library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity counter_9bit is
    port ( counter_9bit_rst_n, counter_9bit_clk, counter_9bit_en : in std_logic;
         counter_9bit_out: out std_logic_vector(8 downto 0));
end counter_9bit;

architecture BEHAVIORAL of counter_9bit is

    signal count : std_logic_vector(8 downto 0);
begin

    process(counter_9bit_rst_n,counter_9bit_clk)
    begin
        if (counter_9bit_rst_n = '0') then
            count <= "000000000";
        elsif (counter_9bit_clk'event and counter_9bit_clk = '1') then
            if (counter_9bit_en='1') then
                count <= count + 1;
            end if;
        end if;
    end process;

    counter_9bit_out <= count;
end BEHAVIORAL;