library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Keccak_core is
    port(
        Keccak_CLK, Keccak_RST_N : in std_logic;
        Keccak_IN_STATE: in k_state;
        Keccak_nr_round: in unsigned(4 downto 0);
        Keccak_OUT_STATE: out k_state
    );
end entity Keccak_core;

architecture RTL of Keccak_core is

    component keccak_round
    	port(
    		clk, rst_n            : in  std_logic;
    		round_in              : in  k_state;
    		round_constant_signal : in  std_logic_vector(7 downto 0);
    		round_out             : out k_state
    	);
    end component keccak_round;

    component keccak_round_constants_gen
    	port(
    		round_number              : in  unsigned(4 downto 0);
    		round_constant_signal_out : out std_logic_vector(7 downto 0)
    	);
    end component keccak_round_constants_gen;

    component Keccak_2to1mux
        port(
            x, y   : in  k_state;
            s      : in  std_logic;
            output : out k_state
        );
    end component Keccak_2to1mux;


    signal KECCAK_feedback_State_S: k_state;

    signal round_constant_signal: std_logic_vector(7 downto 0);

begin


    Keccak_permutation: keccak_round
        port map(
            clk => Keccak_CLK,
            rst_n => Keccak_RST_N,
            round_in              => Keccak_IN_STATE,
            round_constant_signal => round_constant_signal,
            round_out             => KECCAK_feedback_State_S
        );

    keccak_gen: keccak_round_constants_gen
        port map(
            round_number              => Keccak_nr_round,
            round_constant_signal_out => round_constant_signal
        );


    Keccak_OUT_STATE <= KECCAK_feedback_State_S;


end architecture RTL;
