library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_MEM is
    generic(
        data_length    : positive := 5; -- length of each row
        address_length : positive := 2  -- address bits = log2(number_of_rows)
    );
    port(
       r_MEM_IN_CLK      : in  std_logic;
       r_MEM_IN_ADDRESS  : in  std_logic_vector(address_length - 1 downto 0);
       r_MEM_OUT         : out std_logic_vector(data_length - 1 downto 0)
    );
end entity r_MEM;

architecture BEHAVIORAL of r_MEM is

    type matrix is array (0 to 3) of std_logic_vector(data_length - 1 downto 0);
    constant rom : matrix := (
        0    => std_logic_vector(to_signed(17, 5)),
        1      => std_logic_vector(to_signed(9, 5)),
        2     => std_logic_vector(to_signed(21, 5)),
        3     => std_logic_vector(to_signed(17, 5)),
        others => "00000"
    );

begin

    decoder : process(r_MEM_IN_ADDRESS) is
        variable index : natural;
    begin
        index  := to_integer(unsigned(r_MEM_IN_ADDRESS));
       r_MEM_OUT <= rom(index);
    end process decoder;

end architecture BEHAVIORAL;
