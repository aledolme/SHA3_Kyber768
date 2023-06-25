-- bN_mux4to1 is a generic multiplexer with for Keccak state 4 inputs and 1 output. 
library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bN_4to1mux is
    generic (N : positive := 8);
    port(
        IN_0   : in  std_logic_vector(N-1 downto 0);
        IN_1   : in  std_logic_vector(N-1 downto 0);
        IN_2   : in  std_logic_vector(N-1 downto 0);
        IN_3   : in  std_logic_vector(N-1 downto 0);
        S      : in  std_logic_vector(1 downto 0);
        OUTPUT : out std_logic_vector(N-1 downto 0)
    );
end bN_4to1mux;

architecture STRUCTURAL of bN_4to1mux is

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

    