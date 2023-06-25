library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_div is
    port(
        output_div_IN : in std_logic_vector(1023 downto 0);
        output_div_sel: in std_logic_vector(3 downto 0);
        output_div_OUT: out std_logic_vector(63 downto 0)
    );
end entity output_div;

architecture RTL of output_div is

    component bN_2to1mux
        generic(N : positive := 8);
        port(
            x, y   : in  std_logic_vector(N-1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N-1 downto 0)
        );
    end component bN_2to1mux;

    signal out0_a, out0_b, out0_c, out0_d, out0_e, out0_f, out0_g, out0_h: std_logic_vector(63 downto 0);
    signal out1_a, out1_b, out1_c, out1_d: std_logic_vector(63 downto 0);
    signal out2_a, out2_b: std_logic_vector(63 downto 0);


begin

    out_div_mux0_a: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(1023 downto 960),
            y      => output_div_IN(959 downto 896),
            s      => output_div_sel(0),
            output => out0_a
        );

    out_div_mux0_b: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(895 downto 832),
            y      => output_div_IN(831 downto 768),
            s      => output_div_sel(0),
            output => out0_b
        );


    out_div_mux0_c: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(767 downto 704),
            y      => output_div_IN(703 downto 640),
            s      => output_div_sel(0),
            output => out0_c
        );

    out_div_mux0_d: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(639 downto 576),
            y      => output_div_IN(575 downto 512),
            s      => output_div_sel(0),
            output => out0_d
        );

    out_div_mux0_e: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(511 downto 448),
            y      => output_div_IN(447 downto 384),
            s      => output_div_sel(0),
            output => out0_e
        );

    out_div_mux0_f: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(383 downto 320),
            y      => output_div_IN(319 downto 256),
            s      => output_div_sel(0),
            output => out0_f
        );

    out_div_mux0_g: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(255 downto 192),
            y      => output_div_IN(191 downto 128),
            s      => output_div_sel(0),
            output => out0_g
        );

    out_div_mux0_h: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => output_div_IN(127 downto 64),
            y      => output_div_IN(63 downto 0),
            s      => output_div_sel(0),
            output => out0_h
        );
        
    out_div_mux1_a: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out0_a,
            y      => out0_b,
            s      => output_div_sel(1),
            output => out1_a
        );

    out_div_mux1_b: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out0_c,
            y      => out0_d,
            s      => output_div_sel(1),
            output => out1_b
        );
        
    out_div_mux1_c: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out0_e,
            y      => out0_f,
            s      => output_div_sel(1),
            output => out1_c
        );
        
    out_div_mux1_d: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out0_g,
            y      => out0_h,
            s      => output_div_sel(1),
            output => out1_d
        );
 
     out_div_mux2_a: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out1_a,
            y      => out1_b,
            s      => output_div_sel(2),
            output => out2_a
        );       
    
     out_div_mux2_b: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out1_c,
            y      => out1_d,
            s      => output_div_sel(2),
            output => out2_b
        );       
    
     out_div_mux3_a: bN_2to1mux
        generic map(
            N => 64
        )
        port map(
            x      => out2_a,
            y      => out2_b,
            s      => output_div_sel(3),
            output => output_div_OUT
        );       
    


end architecture RTL;
