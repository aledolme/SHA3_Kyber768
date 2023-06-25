library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VSX_MODULE is
    port(
        VSX_IN_STATE: in k_state;
        VSX_IN_MESSAGE: in std_logic_vector(1343 downto 0);
        VSX_SEL:    in std_logic_vector(1 downto 0);
        VSX_OUT_STATE: out k_state
    );
end entity VSX_MODULE;

architecture RTL of VSX_MODULE is

    component Keccak_2to1mux
        port(
            x      : in  k_state;
            y      : in  k_state;
            s      : in  std_logic;
            output : out k_state
        );
    end component Keccak_2to1mux;

    signal XORED_State_S: std_logic_vector(1343 downto 0) := (others=>'0');
    signal SHA3_256, SHA3_512, SHAKE128, SHAKE256, mux03_out, mux04_out: k_state;

begin


    ---XORING--------------------------------------------------------------------------------------------------------------------------
    VSX_00: for row in 0 to 3 generate
        VSX_01: for col in 0 to 4 generate
            VSX_02: for i in 0 to 63 generate
                XORED_State_S(row*320+col*64+i)<= VSX_IN_STATE(row)(col)(i) xor VSX_IN_MESSAGE(row*320+col*64+i);
            end generate;
        end generate;
    end generate;


    VSX_03: for i in 0 to 63 generate
        XORED_State_S(4*320+0*64+i)<= VSX_IN_STATE(4)(0)(i) xor VSX_IN_MESSAGE(4*320+0*64+i);
    end generate;


    ----------------------------------------------------------------------------------------------------------------------------------
    --SHA3_256------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------
    SHA3_256_contruction_00: for row in 0 to 2 generate
        SHA3_256_contruction_00: for col in 0 to 4 generate
            SHA3_256_contruction_00_1: for i in 0 to 63 generate
                SHA3_256(row)(col)(i)<= XORED_State_S(row*320+col*64+i);
            end generate;
        end generate;
    end generate;

    
    SHA3_256_contruction_03: for col in 0 to 1 generate
        SHA3_256_contruction_04: for i in 0 to 63 generate
            SHA3_256(3)(col)(i)<= XORED_State_S(3*320+col*64+i);
        end generate;
    end generate;

    SHA3_256_contruction_05: for col in 2 to 4 generate
            SHA3_256(3)(col)<= VSX_IN_STATE(3)(col);
        end generate;

    SHA3_256_contruction_07: for col in 0 to 4 generate
            SHA3_256(4)(col)<= VSX_IN_STATE(4)(col);
    end generate;


    ----------------------------------------------------------------------------------------------------------------------------------
    --SHA3_512---------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------;
    SHA3_512_contruction_00: for col in 0 to 4 generate
        SHA3_512_contruction_01: for i in 0 to 63 generate
            SHA3_512(0)(col)(i)<= XORED_State_S(0*320+col*64+i);
        end generate;
    end generate;

    SHA3_512_contruction_03: for col in 0 to 3 generate
        SHA3_512_contruction_04: for i in 0 to 63 generate
            SHA3_512(1)(col)(i)<= XORED_State_S(1*320+col*64+i);
        end generate;
    end generate;

    SHA3_512(1)(4)<= VSX_IN_STATE(1)(4);
     
    SHA3_512_contruction_05: for row in 2 to 4 generate
        SHA3_512_contruction_06: for col in 0 to 4 generate
            SHA3_512(row)(col)<= VSX_IN_STATE(row)(col);
    end generate;
    end generate;


    ----------------------------------------------------------------------------------------------------------------------------------
    --SHAKE128---------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------
    SHAKE128_contruction_00: for row in 0 to 3 generate
        SHAKE128_contruction_01: for col in 0 to 4 generate
            SHAKE128_contruction_02: for i in 0 to 63 generate
                SHAKE128(row)(col)(i)<= XORED_State_S(row*320+col*64+i);
            end generate;
        end generate;
    end generate;


    SHAKE128_contruction_03: for i in 0 to 63 generate
        SHAKE128(4)(0)(i)<= XORED_State_S(4*320+0*64+i);
    end generate;

    SHAKE128_contruction_04: for col in 1 to 4 generate
        SHAKE128_contruction_05:for i in 0 to 63 generate
            SHAKE128(4)(col)<= VSX_IN_STATE(4)(col);
        end generate;
    end generate;


    ----------------------------------------------------------------------------------------------------------------------------------
    --SHAKE256---------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------
    SHAKE256_contruction_00: for row in 0 to 2 generate
        SHAKE256_contruction_01: for col in 0 to 4 generate
            SHAKE256_contruction_02: for i in 0 to 63 generate
                SHAKE256(row)(col)(i)<= XORED_State_S(row*320+col*64+i);
            end generate;
        end generate;
    end generate;

    SHAKE256_contruction_03: for col in 0 to 1 generate
        SHAKE256_contruction_04:for i in 0 to 63 generate
            SHAKE256(3)(col)(i)<= XORED_State_S(3*320+col*64+i);
        end generate;
    end generate;

    SHAKE256_contruction_05: for col in 2 to 4 generate
            SHAKE256(3)(col)<= VSX_IN_STATE(3)(col);
        end generate;

    SHAKE256_contruction_06: for col in 0 to 4 generate
            SHAKE256(4)(col)<= VSX_IN_STATE(4)(col);
    end generate;


    ---------------------------------------------------------------------------------------------------------------------------------------
    mux03: Keccak_2to1mux
        port map(
            x      => SHA3_256,
            y      => SHA3_512,
            s      => VSX_SEL(0),
            output => mux03_out
        );

    mux04: Keccak_2to1mux
        port map(
            x      => SHAKE128,
            y      => SHAKE256,
            s      => VSX_SEL(0),
            output => mux04_out
        );
    
    mux05: Keccak_2to1mux
        port map(
            x      => mux03_out,
            y      => mux04_out,
            s      => VSX_SEL(1),
            output => VSX_OUT_STATE
        );
        



end architecture RTL;
