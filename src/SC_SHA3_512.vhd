library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SC_SHA3_512 is
    port(
        SC_SHA3_512_CLK: IN std_logic;
        SC_SHA3_512_RST_N: IN std_logic;
        SC_SHA3_512_stream_in: IN std_logic_vector(575 downto 0);
        SC_SHA3_512_en: IN std_logic;
        SC_SHA3_512_mux: IN std_logic_vector(4 downto 0);
        SC_SHA3_512_stream_out: OUT std_logic_vector(575 downto 0)
    );
end entity SC_SHA3_512;

architecture RTL of SC_SHA3_512 is

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

    component bN_2to1mux
        generic(N : positive := 8);
        port(
            x, y   : in  std_logic_vector(N-1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N-1 downto 0)
        );
    end component bN_2to1mux;

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

    signal SC_stream_out1, SC_stream_out2, SC_stream_out3, SC_stream_out4: std_logic_vector(575 downto 0);
    signal SC_stream_out5, SC_stream_out6, SC_stream_out7, SC_stream_out8: std_logic_vector(575 downto 0);
    signal SC_stream_out9, SC_stream_out10: std_logic_vector(575 downto 0);

    signal i1a_out, i1b_out: std_logic_vector(575 downto 0);
    signal i2a_out, i2b_out, i2c_out, i2d_out : std_logic_vector(575 downto 0);
    signal i3a_out, i3b_out, i3c_out : std_logic_vector(575 downto 0);

begin


    i_reg1: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_SHA3_512_stream_in,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out1
        );

    i_reg2: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out1,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out2
        );

    i_reg3: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out2,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out3
        );

    i_reg4: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out3,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out4
        );

    i_reg5: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out4,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out5
        );

    i_reg6: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out5,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out6
        );

    i_reg7: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out6,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out7
        );

    i_reg8: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out7,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out8
        );

    i_reg9: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out8,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out9
        );

    i_reg10: reg_en_rst_n
        generic map(
            N => 576
        )
        port map(
            D     => SC_stream_out9,
            en    => SC_SHA3_512_en,
            rst_n => SC_SHA3_512_RST_N,
            clk   => SC_SHA3_512_CLK,
            Q     => SC_stream_out10
        );


    i_0: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => i1a_out,
            y      => i1b_out,
            s      => SC_SHA3_512_mux(0),
            output => SC_SHA3_512_stream_out
        );

    i_1a: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => i2a_out,
            y      => i2b_out,
            s      => SC_SHA3_512_mux(1),
            output => i1a_out
        );

    i_1b: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => i2c_out,
            y      => i2d_out,
            s      => SC_SHA3_512_mux(1),
            output => i1b_out
        );

    i_2a: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => i3a_out,
            y      => SC_stream_out5,
            s      => SC_SHA3_512_mux(2),
            output => i2a_out
        );

    i_2b: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => SC_stream_out3,
            y      => SC_stream_out7,
            s      => SC_SHA3_512_mux(2),
            output => i2b_out
        );

    i_2c: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => i3b_out,
            y      => i3c_out,
            s      => SC_SHA3_512_mux(2),
            output => i2c_out
        );

    i_2d: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => SC_stream_out4,
            y      => SC_stream_out8,
            s      => SC_SHA3_512_mux(2),
            output => i2d_out
        );

    i_3a: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => SC_SHA3_512_stream_in,
            y      => SC_stream_out1,
            s      => SC_SHA3_512_mux(3),
            output => i3a_out
        );

    i_3b: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => SC_stream_out2,
            y      => SC_stream_out9,
            s      => SC_SHA3_512_mux(3),
            output => i3b_out
        );

    i_3c: bN_2to1mux
        generic map(
            N => 576
        )
        port map(
            x      => SC_stream_out6,
            y      => SC_stream_out10,
            s      => SC_SHA3_512_mux(3),
            output => i3c_out
        );

    
        
end architecture RTL;