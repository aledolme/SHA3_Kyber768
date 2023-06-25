library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sel_MUX_MEM is
    generic(
        data_length    : positive := 5; -- length of each row
        address_length : positive := 6  -- address bits = log2(number_of_rows)
    );
    port(
        sel_MUX_MEM_IN_CLK      : in  std_logic;
        sel_MUX_MEM_IN_ADDRESS  : in  std_logic_vector(address_length - 1 downto 0);
        sel_MUX_MEM_OUT         : out std_logic_vector(data_length - 1 downto 0)
    );
end entity sel_MUX_MEM;

architecture BEHAVIORAL of sel_MUX_MEM is

    type matrix is array (0 to 64) of std_logic_vector(data_length - 1 downto 0);
    constant rom : matrix := (
        0   => std_logic_vector(to_signed(0, 5)),
        1   => std_logic_vector(to_signed(0, 5)),
        2   => std_logic_vector(to_signed(1, 5)),
        3   => std_logic_vector(to_signed(1, 5)),
        4   => std_logic_vector(to_signed(2, 5)),
        5   => std_logic_vector(to_signed(2, 5)),
        6   => std_logic_vector(to_signed(2, 5)),
        7   => std_logic_vector(to_signed(2, 5)),
        8   => std_logic_vector(to_signed(3, 5)),
        9   => std_logic_vector(to_signed(3, 5)),
        10  => std_logic_vector(to_signed(2, 5)),
        11  => std_logic_vector(to_signed(1, 5)),
        32  => std_logic_vector(to_signed(0, 5)),
        35  => std_logic_vector(to_signed(1, 5)),
        37  => std_logic_vector(to_signed(2, 5)),
        39  => std_logic_vector(to_signed(3, 5)),
        41  => std_logic_vector(to_signed(4, 5)),
        42  => std_logic_vector(to_signed(5, 5)),
        44  => std_logic_vector(to_signed(6, 5)),
        46  => std_logic_vector(to_signed(7, 5)),
        49  => std_logic_vector(to_signed(13, 5)),
        50  => std_logic_vector(to_signed(9, 5)),
        51  => std_logic_vector(to_signed(7, 5)),
        52  => std_logic_vector(to_signed(6, 5)),
        53  => std_logic_vector(to_signed(5, 5)),
        54  => std_logic_vector(to_signed(4, 5)),
        55  => std_logic_vector(to_signed(3, 5)),
        56  => std_logic_vector(to_signed(2, 5)),
        57  => std_logic_vector(to_signed(8, 5)),
        58  => std_logic_vector(to_signed(6, 5)),
        59  => std_logic_vector(to_signed(0, 5)),
        others => "00000"
    );

begin

    decoder : process(sel_MUX_MEM_IN_ADDRESS) is
        variable index : natural;
    begin
        index  := to_integer(unsigned(sel_MUX_MEM_IN_ADDRESS));
        sel_MUX_MEM_OUT <= rom(index);
    end process decoder;

end architecture BEHAVIORAL;
