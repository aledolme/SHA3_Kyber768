library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity b_2to1mux is
	port ( x, y 	: in std_logic;
	       s   		: in std_logic;
	       output	: out std_logic
		  );
end entity b_2to1mux;

architecture Structure of b_2to1mux is
begin
	
	output <= (not(s) and x) or (s and y);
	
end architecture Structure;