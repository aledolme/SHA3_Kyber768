library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IN_BUFFER is
    port(
        IN_BUFFER_CLK : in std_logic;
        IN_BUFFER_RST_N : in std_logic;
        IN_BUFFER_EN : in std_logic;
        IN_BUFFER_INPUT: in std_logic_vector(63 downto 0);
        IN_BUFFER_OUTPUT: out std_logic_vector(1087 downto 0)
    );
end entity IN_BUFFER;

architecture RTL of IN_BUFFER is

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
    

    signal OUT1, OUT2, OUT3, OUT4, OUT5, OUT6, OUT7, OUT8, OUT9, OUT10, OUT11, OUT12, OUT13: std_logic_vector(63 downto 0);
    signal OUT14, OUT15, OUT16, OUT17: std_logic_vector(63 downto 0);


begin

    i_1: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => IN_BUFFER_INPUT,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT1
        );

    i_2: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT1,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT2
        );

    i_3: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT2,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT3
        );

    i_4: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT3,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT4
        );

    i_5: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT4,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT5
        );

    i_6: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT5,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT6
        );

    i_7: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT6,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT7
        );

    i_8: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT7,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT8
        );

    i_9: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT8,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT9
        );

    i_10: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT9,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT10
        );

    i_11: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT10,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT11
        );

    i_12: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT11,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT12
        );

    i_13: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT12,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT13
        );

    i_14: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT13,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT14
        );

    i_15: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT14,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT15
        );

    i_16: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT15,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT16
        );

    i_17: reg_en_rst_n
        generic map(
            N => 64
        )
        port map(
            D     => OUT16,
            en    => IN_BUFFER_EN,
            rst_n => IN_BUFFER_RST_N,
            clk   => IN_BUFFER_CLK,
            Q     => OUT17
        );





    
    IN_BUFFER_OUTPUT <= OUT17 & OUT16 & OUT15 & OUT14 & OUT13 & OUT12 & OUT11 & OUT10 & OUT9 & OUT8 & OUT7 & OUT6 & OUT5 & OUT4 & OUT3 & OUT2 & OUT1;



end architecture RTL;
