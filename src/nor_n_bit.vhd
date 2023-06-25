---------------------------------------------------------------------------------------------
-- Project: Innovative System WS 2021-2022
-- Author: High Speed Group - #3
-- Date: August 2021
-- File: nor_n_bit.vhd
-- Design: ALU unit
---------------------------------------------------------------------------------------------
-- Description: A generic N-bit NOR gate.
----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NOR_N_BIT is
    generic(N : positive := 32);
    port(
        NOR_N_BIT_IN  : in  std_logic_vector(N - 1 downto 0);
        NOR_N_BIT_OUT : out std_logic
    );
end NOR_N_BIT;

architecture STRUCTURAL of NOR_N_BIT is

begin
    
    -- NOR between N bit
    nor_nbit : process(NOR_N_BIT_IN)
        variable TEMP_V : std_logic;
    begin
        TEMP_V       := NOR_N_BIT_IN(0);
        for I in 1 to N - 1 loop
            TEMP_V := TEMP_V or NOR_N_BIT_IN(I);
        end loop;
        NOR_N_BIT_OUT <= TEMP_V;
    end process;

end STRUCTURAL;
