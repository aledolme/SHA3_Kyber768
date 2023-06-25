library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity PADDING is
    port(
        PADD_MESS_IN: in std_logic_vector(1087 downto 0);
        PADD_CLK: in std_logic;
        PADD_MODE: in std_logic_vector(1 downto 0);
        PADD_OP: in std_logic_vector(1 downto 0);
        PADD_LAST_BLOCK: in std_logic;
        PADD_MESS_OUT: out std_logic_vector(1343 downto 0)
    );
end entity PADDING;



architecture RTL of PADDING is

    component bN_2to1mux
        generic(N : positive := 1343);
        port(
            x, y   : in  std_logic_vector(N-1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N-1 downto 0)
        );
    end component bN_2to1mux;

    component PAD_SHA3_256
        port(
            PADD_SHA3_IN_256  : in  std_logic_vector(767 downto 0);
            PADD_SHA3_OP      : in  std_logic_vector(1 downto 0);
            PADD_SHA3_OUT_256 : out k_state
        );
    end component PAD_SHA3_256;

    component PAD_SHA3_512
        port(
            PADD_SHA3_IN_512  : in  std_logic_vector(511 downto 0);
            PADD_SHA3_OP      : in  std_logic_vector(1 downto 0);
            PADD_SHA3_OUT_512 : out k_state
        );
    end component PAD_SHA3_512;

    component PAD_SHAKE128
    	port(
    		PADD_SHAKE128_IN  : in  std_logic_vector(271 downto 0);
    		PADD_SHAKE128_OUT : out k_state
    	);
    end component PAD_SHAKE128;

    component PAD_SHAKE256
        port(
            PADD_SHAKE256_IN  : in  std_logic_vector(511 downto 0);
            PADD_SHA3_OP      : in  std_logic_vector(1 downto 0);
            PADD_SHAKE256_OUT : out k_state
        );
    end component PAD_SHAKE256;

    component Keccak_4to1mux
        port(
            IN_0   : in  k_state;
            IN_1   : in  k_state;
            IN_2   : in  k_state;
            IN_3   : in  k_state;
            S      : in  std_logic_vector(1 downto 0);
            OUTPUT : out k_state
        );
    end component Keccak_4to1mux;

    signal zero_256: std_logic_vector(255 downto 0);
    signal PADD_OUT: std_logic_vector(1343 downto 0);
    signal NO_PADD: std_logic_vector(1087 downto 0);
    signal NO_PADD_OUT, NO_PADD_OUT_256, NO_PADD_OUT_512: std_logic_vector(1343 downto 0);

    signal PADD_MESS_SHA256, PADD_MESS_SHA512, PADD_MESS_SHAKE128, PADD_MESS_SHAKE256, PADD_MESS_K: k_state;

begin

    zero_256 <= (others=>'0');
    

    NO_PADD_OUT01:   for col in 0 to 16 generate
        NO_PADD(64*col+0)<=PADD_MESS_IN(1088-64*col-8);
        NO_PADD(64*col+1)<=PADD_MESS_IN(1088-64*col-7);
        NO_PADD(64*col+2)<=PADD_MESS_IN(1088-64*col-6);
        NO_PADD(64*col+3)<=PADD_MESS_IN(1088-64*col-5);
        NO_PADD(64*col+4)<=PADD_MESS_IN(1088-64*col-4);
        NO_PADD(64*col+5)<=PADD_MESS_IN(1088-64*col-3);
        NO_PADD(64*col+6)<=PADD_MESS_IN(1088-64*col-2);
        NO_PADD(64*col+7)<=PADD_MESS_IN(1088-64*col-1);

        NO_PADD(64*col+8)<=PADD_MESS_IN(1088-64*col-16);
        NO_PADD(64*col+9)<=PADD_MESS_IN(1088-64*col-15);
        NO_PADD(64*col+10)<=PADD_MESS_IN(1088-64*col-14);
        NO_PADD(64*col+11)<=PADD_MESS_IN(1088-64*col-13);
        NO_PADD(64*col+12)<=PADD_MESS_IN(1088-64*col-12);
        NO_PADD(64*col+13)<=PADD_MESS_IN(1088-64*col-11);
        NO_PADD(64*col+14)<=PADD_MESS_IN(1088-64*col-10);
        NO_PADD(64*col+15)<=PADD_MESS_IN(1088-64*col-9);

        NO_PADD(64*col+16)<=PADD_MESS_IN(1088-64*col-24);
        NO_PADD(64*col+17)<=PADD_MESS_IN(1088-64*col-23);
        NO_PADD(64*col+18)<=PADD_MESS_IN(1088-64*col-22);
        NO_PADD(64*col+19)<=PADD_MESS_IN(1088-64*col-21);
        NO_PADD(64*col+20)<=PADD_MESS_IN(1088-64*col-20);
        NO_PADD(64*col+21)<=PADD_MESS_IN(1088-64*col-19);
        NO_PADD(64*col+22)<=PADD_MESS_IN(1088-64*col-18);
        NO_PADD(64*col+23)<=PADD_MESS_IN(1088-64*col-17);

        NO_PADD(64*col+24)<=PADD_MESS_IN(1088-64*col-32);
        NO_PADD(64*col+25)<=PADD_MESS_IN(1088-64*col-31);
        NO_PADD(64*col+26)<=PADD_MESS_IN(1088-64*col-30);
        NO_PADD(64*col+27)<=PADD_MESS_IN(1088-64*col-29);
        NO_PADD(64*col+28)<=PADD_MESS_IN(1088-64*col-28);
        NO_PADD(64*col+29)<=PADD_MESS_IN(1088-64*col-27);
        NO_PADD(64*col+30)<=PADD_MESS_IN(1088-64*col-26);
        NO_PADD(64*col+31)<=PADD_MESS_IN(1088-64*col-25);

        NO_PADD(64*col+32)<=PADD_MESS_IN(1088-64*col-40);
        NO_PADD(64*col+33)<=PADD_MESS_IN(1088-64*col-39);
        NO_PADD(64*col+34)<=PADD_MESS_IN(1088-64*col-38);
        NO_PADD(64*col+35)<=PADD_MESS_IN(1088-64*col-37);
        NO_PADD(64*col+36)<=PADD_MESS_IN(1088-64*col-36);
        NO_PADD(64*col+37)<=PADD_MESS_IN(1088-64*col-35);
        NO_PADD(64*col+38)<=PADD_MESS_IN(1088-64*col-34);
        NO_PADD(64*col+39)<=PADD_MESS_IN(1088-64*col-33);

        NO_PADD(64*col+40)<=PADD_MESS_IN(1088-64*col-48);
        NO_PADD(64*col+41)<=PADD_MESS_IN(1088-64*col-47);
        NO_PADD(64*col+42)<=PADD_MESS_IN(1088-64*col-46);
        NO_PADD(64*col+43)<=PADD_MESS_IN(1088-64*col-45);
        NO_PADD(64*col+44)<=PADD_MESS_IN(1088-64*col-44);
        NO_PADD(64*col+45)<=PADD_MESS_IN(1088-64*col-43);
        NO_PADD(64*col+46)<=PADD_MESS_IN(1088-64*col-42);
        NO_PADD(64*col+47)<=PADD_MESS_IN(1088-64*col-41);

        NO_PADD(64*col+48)<=PADD_MESS_IN(1088-64*col-56);
        NO_PADD(64*col+49)<=PADD_MESS_IN(1088-64*col-55);
        NO_PADD(64*col+50)<=PADD_MESS_IN(1088-64*col-54);
        NO_PADD(64*col+51)<=PADD_MESS_IN(1088-64*col-53);
        NO_PADD(64*col+52)<=PADD_MESS_IN(1088-64*col-52);
        NO_PADD(64*col+53)<=PADD_MESS_IN(1088-64*col-51);
        NO_PADD(64*col+54)<=PADD_MESS_IN(1088-64*col-50);
        NO_PADD(64*col+55)<=PADD_MESS_IN(1088-64*col-49);

        NO_PADD(64*col+56)<=PADD_MESS_IN(1088-64*col-64);
        NO_PADD(64*col+57)<=PADD_MESS_IN(1088-64*col-63);
        NO_PADD(64*col+58)<=PADD_MESS_IN(1088-64*col-62);
        NO_PADD(64*col+59)<=PADD_MESS_IN(1088-64*col-61);
        NO_PADD(64*col+60)<=PADD_MESS_IN(1088-64*col-60);
        NO_PADD(64*col+61)<=PADD_MESS_IN(1088-64*col-59);
        NO_PADD(64*col+62)<=PADD_MESS_IN(1088-64*col-58);
        NO_PADD(64*col+63)<=PADD_MESS_IN(1088-64*col-57);
    end generate;

    NO_PADD_OUT_256 <=zero_256 & NO_PADD;
    NO_PADD_OUT_512 <= zero_256 & zero_256 & zero_256 & NO_PADD(1087 downto 512);
    


    i_PAD_SHA3_256: PAD_SHA3_256
        port map(
            PADD_SHA3_IN_256  => PADD_MESS_IN(767 downto 0),
            PADD_SHA3_OP      => PADD_OP,
            PADD_SHA3_OUT_256 => PADD_MESS_SHA256
        );

    i_PAD_SHA3_512: PAD_SHA3_512
        port map(
            PADD_SHA3_IN_512  => PADD_MESS_IN(511 downto 0),
            PADD_SHA3_OP      => PADD_OP,
            PADD_SHA3_OUT_512 => PADD_MESS_SHA512
        );

    i_PAD_SHAKE128: PAD_SHAKE128
        port map(
            PADD_SHAKE128_IN  => PADD_MESS_IN(319 downto 48),
            PADD_SHAKE128_OUT => PADD_MESS_SHAKE128
        );

    i_PAD_SHAKE256: PAD_SHAKE256
        port map(
            PADD_SHAKE256_IN  => PADD_MESS_IN(511 downto 0),
            PADD_SHA3_OP      => PADD_OP,
            PADD_SHAKE256_OUT => PADD_MESS_SHAKE256
        );

    i_MUX_PADDING_OUT: Keccak_4to1mux
        port map(
            IN_0   => PADD_MESS_SHA256,
            IN_1   => PADD_MESS_SHA512,
            IN_2   => PADD_MESS_SHAKE128,
            IN_3   => PADD_MESS_SHAKE256,
            S      => PADD_MODE,
            OUTPUT => PADD_MESS_K
        );

    T01: for row in 0 to 3 generate
        T02:     for col in 0 to 4 generate
            T03:   for i in 0 to 63 generate
                PADD_OUT(row*320+col*64+i)<=PADD_MESS_K(row)(col)(i);
            end generate;
        end generate;
    end generate;

    T04:   for i in 0 to 63 generate
        PADD_OUT(4*320+0*64+i)<=PADD_MESS_K(4)(0)(i);
    end generate;
    
    i_NO_PADD_MUX: bN_2to1mux
        generic map(
            N => 1344
        )
        port map(
            x      => NO_PADD_OUT_256,
            y      => NO_PADD_OUT_512,
            s      => PADD_MODE(0),
            output => NO_PADD_OUT
        );


    i_final_MUX: bN_2to1mux
        generic map(
            N => 1344
        )
        port map(
            x      => NO_PADD_OUT,
            y      => PADD_OUT,
            s      => PADD_LAST_BLOCK,
            output => PADD_MESS_OUT
        );


end architecture RTL;
