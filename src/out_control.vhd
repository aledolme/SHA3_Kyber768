library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity out_control is
    port(
        out_control_MODE: in std_logic_vector(1 downto 0); --00 SHA3-256, 01 SHA3-512, 10 SHAKE128 and 11 SHAKE256
        out_control_OP: in std_logic_vector(1 downto 0);
        out_control_end: out std_logic_vector(4 downto 0)
    );
end entity out_control;

architecture RTL of out_control is

    component bN_2to1mux
        generic(N : positive := 8);
        port(
            x, y   : in  std_logic_vector(N-1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N-1 downto 0)
        );
    end component bN_2to1mux;

    signal a,b,x: std_logic;
    signal out_a: std_logic_vector(3 downto 0);
    signal out_b, out_a_ext: std_logic_vector(4 downto 0);

begin

    --a<=((NOT out_control_OP(1)) AND (NOT out_control_MODE(1) ) AND NOT (out_control_MODE(0))) OR ((NOT out_control_OP(0)) AND (NOT out_control_MODE(1) ) AND NOT (out_control_MODE(0))) OR ((NOT out_control_OP(1)) AND out_control_OP(0) AND out_control_MODE(0) AND out_control_MODE(1));
    a <= ((NOT out_control_OP(1)) AND (NOT out_control_MODE(1)) AND out_control_MODE(0)) OR  ((NOT out_control_OP(0)) AND (NOT out_control_MODE(1) ) AND out_control_MODE(0));
    b<= (NOT out_control_OP(1)) AND (NOT out_control_OP(0)) AND out_control_MODE(0) AND out_control_MODE(1);
    x<=(NOT out_control_MODE(1)) OR out_control_OP(1) OR out_control_OP(0);

    mux_out_control_a: bN_2to1mux
        generic map(
            N => 4
        )
        port map(
            x      => "0011", --7
            y      => "0111", --3
            s      => a,
            output => out_a
        );

    mux_out_control_b: bN_2to1mux
        generic map(
            N => 5
        )
        port map(
            x      => "01011", --11
            y      => "01111", --15
            s      => b,
            output => out_b
        );

    out_a_ext <= '0'& out_a;

    mux_out_control_x: bN_2to1mux
        generic map(
            N => 5
        )
        port map(
            x      => out_b,
            y      => out_a_ext,
            s      => x,
            output => out_control_end
        );

end architecture RTL;
