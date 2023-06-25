library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- N level of flip flop to store std_logic
-- the reset in this block is synchronous

entity flip_flop_N_level_en_rst_n is
    generic(
        N : positive
    );
    port(
        D     : in  std_logic;
        clk   : in  std_logic;
        rst_n : in  std_logic;
        en    : in  std_logic;
        Q     : out std_logic
    );
end entity flip_flop_N_level_en_rst_n;

architecture structure of flip_flop_N_level_en_rst_n is

    component flipflop_en_rst_n
    	port(
    		D     : in  std_logic;
    		clk   : in  std_logic;
    		en    : in  std_logic;
    		rst_n : in  std_logic;
    		Q     : out std_logic
    	);
    end component flipflop_en_rst_n;

    signal Q_internal : std_logic_vector(N - 1 downto 0);

begin

    FD_0 : flipflop_en_rst_n
        port map(
            D     => D,
            clk   => clk,
            en    => en,
            rst_n => rst_n,
            Q     => Q_internal(0)
        );

    G : for i in 1 to N - 1 generate
        FD : flipflop_en_rst_n
            port map(
                D     => Q_internal(i - 1),
                clk   => clk,
                en    => en,
                rst_n => rst_n,
                Q     => Q_internal(i)
            );
    end generate;

    Q <= Q_internal(N-1);

end architecture structure;

