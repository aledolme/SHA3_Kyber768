-- bN_mux4to1 is a generic multiplexer with for Keccak state 4 inputs and 1 output. 
library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Keccak_4to1mux is
    port(
        IN_0   : in  k_state;
        IN_1   : in  k_state;
        IN_2   : in  k_state;
        IN_3   : in  k_state;
        S      : in  std_logic_vector(1 downto 0);
        OUTPUT : out k_state
    );
end Keccak_4to1mux;

architecture STRUCTURAL of Keccak_4to1mux is

begin
    mux: process(S, IN_0, IN_1, IN_2, IN_3)
    begin
        if (S="00") then
            OUTPUT <= IN_0;
        elsif (S="01") then
            OUTPUT <= IN_1;
        elsif (S="10") then
            OUTPUT <= IN_2;
        elsif (S="11") then
            OUTPUT <= IN_3;
        end if;
    end process;

end STRUCTURAL;