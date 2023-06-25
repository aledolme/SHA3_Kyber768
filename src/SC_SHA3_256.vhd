library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SC_SHA3_256 is
    port(
        SC_SHA3_256_CLK: IN std_logic;
        SC_SHA3_256_RST_N: IN std_logic;
        SC_SHA3_256_stream_in: IN std_logic_vector(1087 downto 0);
        SC_SHA3_256_en: IN std_logic;
        SC_SHA3_256_mux: IN std_logic_vector(1 downto 0);
        SC_SHA3_256_stream_out: OUT std_logic_vector(1087 downto 0)
    );
end entity SC_SHA3_256;

architecture RTL of SC_SHA3_256 is

    component reg_en_rst_n
        generic(N : positive := 32);
        port(
            D     : in  std_logic_vector(N - 1 downto 0);
            en    : in  std_logic;
            rst_n : in  std_logic;
            clk   : in  std_logic;
            Q     : out std_logic_vector(N - 1 downto 0)
        );
    end component reg_en_rst_n;

    component bN_4to1mux
        generic(N : positive := 8);
        port(
            IN_0   : in  std_logic_vector(N-1 downto 0);
            IN_1   : in  std_logic_vector(N-1 downto 0);
            IN_2   : in  std_logic_vector(N-1 downto 0);
            IN_3   : in  std_logic_vector(N-1 downto 0);
            S      : in  std_logic_vector(1 downto 0);
            OUTPUT : out std_logic_vector(N-1 downto 0)
        );
    end component bN_4to1mux;

    signal SC_stream_out1, SC_stream_out2, SC_stream_out3: std_logic_vector(1087 downto 0);


begin


    i_reg1: reg_en_rst_n
        generic map(
            N => 1088
        )
        port map(
            D     => SC_SHA3_256_stream_in,
            en    => SC_SHA3_256_en,
            rst_n => SC_SHA3_256_RST_N,
            clk   => SC_SHA3_256_CLK,
            Q     => SC_stream_out1
        );

    i_reg2: reg_en_rst_n
        generic map(
            N => 1088
        )
        port map(
            D     => SC_stream_out1,
            en    => SC_SHA3_256_en,
            rst_n => SC_SHA3_256_RST_N,
            clk   => SC_SHA3_256_CLK,
            Q     => SC_stream_out2
        );

    i_reg3: reg_en_rst_n
        generic map(
            N => 1088
        )
        port map(
            D     => SC_stream_out2,
            en    => SC_SHA3_256_en,
            rst_n => SC_SHA3_256_RST_N,
            clk   => SC_SHA3_256_CLK,
            Q     => SC_stream_out3
        );

    
    i_MUX_stream: bN_4to1mux
        generic map(
            N => 1088
        )
        port map(
            IN_0   => SC_SHA3_256_stream_in,
            IN_1   => SC_stream_out1,
            IN_2   => SC_stream_out2,
            IN_3   => SC_stream_out3,
            S      => SC_SHA3_256_mux,
            OUTPUT => SC_SHA3_256_stream_out
        );

        
        
end architecture RTL;