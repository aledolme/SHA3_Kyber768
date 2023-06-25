library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IN_BUFF_MEM is
    generic(
        data_length    : positive := 8; -- length of each row
        address_length : positive := 3  -- address bits = log2(number_of_rows)
    );
    port(
        IB_MEM_IN_CLK      : in  std_logic;
        IB_MEM_IN_ADDRESS  : in  std_logic_vector(address_length - 1 downto 0);
        IB_MEM_OUT         : out std_logic_vector(data_length - 1 downto 0)
    );
end entity IN_BUFF_MEM;

architecture BEHAVIORAL of IN_BUFF_MEM is

    type matrix is array (0 to 13) of std_logic_vector(data_length - 1 downto 0);
    constant rom : matrix := (
        0    => std_logic_vector(to_signed(148, 8)),
        1    => std_logic_vector(to_signed(137, 8)),
        2      => std_logic_vector(to_signed(4, 8)),
        4      => std_logic_vector(to_signed(4, 8)),
        5     => std_logic_vector(to_signed(8, 8)),
        6     => std_logic_vector(to_signed(145, 8)),
        8     => std_logic_vector(to_signed(5, 8)),
        12     => std_logic_vector(to_signed(5, 8)),
        13     => std_logic_vector(to_signed(8, 8)),
        others => X"00"
    );

begin

    decoder : process(IB_MEM_IN_ADDRESS) is
        variable index : natural;
    begin
        index  := to_integer(unsigned(IB_MEM_IN_ADDRESS));
        IB_MEM_OUT <= rom(index);
    end process decoder;

end architecture BEHAVIORAL;
