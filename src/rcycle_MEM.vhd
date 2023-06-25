library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rcycle_MEM is
    port(
        rcycle_CLK: std_logic;
        rcycle_MEM_IN_ADDRESS  : in  std_logic_vector(3 downto 0);
        rcycle_MEM_OUT         : out std_logic_vector(4 downto 0)
    );
end entity rcycle_MEM;

architecture BEHAVIORAL of rcycle_MEM is

begin

    rcycle_cycle_selector: process(rcycle_MEM_IN_ADDRESS)
    begin
        case rcycle_MEM_IN_ADDRESS is
            when "0000" => rcycle_MEM_OUT <= "01001";
            when "0001" => rcycle_MEM_OUT <= "01001";
            when "0110" => rcycle_MEM_OUT <= "10001";
            when others =>  rcycle_MEM_OUT <= "00001";
        end case;
    end process;
    
    
end architecture BEHAVIORAL;
