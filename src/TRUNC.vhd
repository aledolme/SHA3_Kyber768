library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TRUNC is
    port(
        Keccak_State_S: in k_state;
        TRUNC_out: out std_logic_vector(1023 downto 0)
    );
end entity TRUNC;

architecture RTL of TRUNC is

signal TRUNCATED_out_REG: k_state;

begin

    TRUNCATED_out_REG00: for row in 1 to 5 generate
        TRUNCATED_out_REG01:   for col in 1 to 5 generate

            TRUNCATED_out_REG(row-1)(col-1)(0)<=Keccak_State_S(5-row)(5-col)(64-8);
            TRUNCATED_out_REG(row-1)(col-1)(1)<=Keccak_State_S(5-row)(5-col)(64-7);
            TRUNCATED_out_REG(row-1)(col-1)(2)<=Keccak_State_S(5-row)(5-col)(64-6);
            TRUNCATED_out_REG(row-1)(col-1)(3)<=Keccak_State_S(5-row)(5-col)(64-5);
            TRUNCATED_out_REG(row-1)(col-1)(4)<=Keccak_State_S(5-row)(5-col)(64-4);
            TRUNCATED_out_REG(row-1)(col-1)(5)<=Keccak_State_S(5-row)(5-col)(64-3);
            TRUNCATED_out_REG(row-1)(col-1)(6)<=Keccak_State_S(5-row)(5-col)(64-2);
            TRUNCATED_out_REG(row-1)(col-1)(7)<=Keccak_State_S(5-row)(5-col)(64-1);

            TRUNCATED_out_REG(row-1)(col-1)(8)<=Keccak_State_S(5-row)(5-col)(64-16);
            TRUNCATED_out_REG(row-1)(col-1)(9)<=Keccak_State_S(5-row)(5-col)(64-15);
            TRUNCATED_out_REG(row-1)(col-1)(10)<=Keccak_State_S(5-row)(5-col)(64-14);
            TRUNCATED_out_REG(row-1)(col-1)(11)<=Keccak_State_S(5-row)(5-col)(64-13);
            TRUNCATED_out_REG(row-1)(col-1)(12)<=Keccak_State_S(5-row)(5-col)(64-12);
            TRUNCATED_out_REG(row-1)(col-1)(13)<=Keccak_State_S(5-row)(5-col)(64-11);
            TRUNCATED_out_REG(row-1)(col-1)(14)<=Keccak_State_S(5-row)(5-col)(64-10);
            TRUNCATED_out_REG(row-1)(col-1)(15)<=Keccak_State_S(5-row)(5-col)(64-9);

            TRUNCATED_out_REG(row-1)(col-1)(16)<=Keccak_State_S(5-row)(5-col)(64-24);
            TRUNCATED_out_REG(row-1)(col-1)(17)<=Keccak_State_S(5-row)(5-col)(64-23);
            TRUNCATED_out_REG(row-1)(col-1)(18)<=Keccak_State_S(5-row)(5-col)(64-22);
            TRUNCATED_out_REG(row-1)(col-1)(19)<=Keccak_State_S(5-row)(5-col)(64-21);
            TRUNCATED_out_REG(row-1)(col-1)(20)<=Keccak_State_S(5-row)(5-col)(64-20);
            TRUNCATED_out_REG(row-1)(col-1)(21)<=Keccak_State_S(5-row)(5-col)(64-19);
            TRUNCATED_out_REG(row-1)(col-1)(22)<=Keccak_State_S(5-row)(5-col)(64-18);
            TRUNCATED_out_REG(row-1)(col-1)(23)<=Keccak_State_S(5-row)(5-col)(64-17);

            TRUNCATED_out_REG(row-1)(col-1)(24)<=Keccak_State_S(5-row)(5-col)(64-32);
            TRUNCATED_out_REG(row-1)(col-1)(25)<=Keccak_State_S(5-row)(5-col)(64-31);
            TRUNCATED_out_REG(row-1)(col-1)(26)<=Keccak_State_S(5-row)(5-col)(64-30);
            TRUNCATED_out_REG(row-1)(col-1)(27)<=Keccak_State_S(5-row)(5-col)(64-29);
            TRUNCATED_out_REG(row-1)(col-1)(28)<=Keccak_State_S(5-row)(5-col)(64-28);
            TRUNCATED_out_REG(row-1)(col-1)(29)<=Keccak_State_S(5-row)(5-col)(64-27);
            TRUNCATED_out_REG(row-1)(col-1)(30)<=Keccak_State_S(5-row)(5-col)(64-26);
            TRUNCATED_out_REG(row-1)(col-1)(31)<=Keccak_State_S(5-row)(5-col)(64-25);

            TRUNCATED_out_REG(row-1)(col-1)(32)<=Keccak_State_S(5-row)(5-col)(64-40);
            TRUNCATED_out_REG(row-1)(col-1)(33)<=Keccak_State_S(5-row)(5-col)(64-39);
            TRUNCATED_out_REG(row-1)(col-1)(34)<=Keccak_State_S(5-row)(5-col)(64-38);
            TRUNCATED_out_REG(row-1)(col-1)(35)<=Keccak_State_S(5-row)(5-col)(64-37);
            TRUNCATED_out_REG(row-1)(col-1)(36)<=Keccak_State_S(5-row)(5-col)(64-36);
            TRUNCATED_out_REG(row-1)(col-1)(37)<=Keccak_State_S(5-row)(5-col)(64-35);
            TRUNCATED_out_REG(row-1)(col-1)(38)<=Keccak_State_S(5-row)(5-col)(64-34);
            TRUNCATED_out_REG(row-1)(col-1)(39)<=Keccak_State_S(5-row)(5-col)(64-33);

            TRUNCATED_out_REG(row-1)(col-1)(40)<=Keccak_State_S(5-row)(5-col)(64-48);
            TRUNCATED_out_REG(row-1)(col-1)(41)<=Keccak_State_S(5-row)(5-col)(64-47);
            TRUNCATED_out_REG(row-1)(col-1)(42)<=Keccak_State_S(5-row)(5-col)(64-46);
            TRUNCATED_out_REG(row-1)(col-1)(43)<=Keccak_State_S(5-row)(5-col)(64-45);
            TRUNCATED_out_REG(row-1)(col-1)(44)<=Keccak_State_S(5-row)(5-col)(64-44);
            TRUNCATED_out_REG(row-1)(col-1)(45)<=Keccak_State_S(5-row)(5-col)(64-43);
            TRUNCATED_out_REG(row-1)(col-1)(46)<=Keccak_State_S(5-row)(5-col)(64-42);
            TRUNCATED_out_REG(row-1)(col-1)(47)<=Keccak_State_S(5-row)(5-col)(64-41);

            TRUNCATED_out_REG(row-1)(col-1)(48)<=Keccak_State_S(5-row)(5-col)(64-56);
            TRUNCATED_out_REG(row-1)(col-1)(49)<=Keccak_State_S(5-row)(5-col)(64-55);
            TRUNCATED_out_REG(row-1)(col-1)(50)<=Keccak_State_S(5-row)(5-col)(64-54);
            TRUNCATED_out_REG(row-1)(col-1)(51)<=Keccak_State_S(5-row)(5-col)(64-53);
            TRUNCATED_out_REG(row-1)(col-1)(52)<=Keccak_State_S(5-row)(5-col)(64-52);
            TRUNCATED_out_REG(row-1)(col-1)(53)<=Keccak_State_S(5-row)(5-col)(64-51);
            TRUNCATED_out_REG(row-1)(col-1)(54)<=Keccak_State_S(5-row)(5-col)(64-50);
            TRUNCATED_out_REG(row-1)(col-1)(55)<=Keccak_State_S(5-row)(5-col)(64-49);

            TRUNCATED_out_REG(row-1)(col-1)(56)<=Keccak_State_S(5-row)(5-col)(64-64);
            TRUNCATED_out_REG(row-1)(col-1)(57)<=Keccak_State_S(5-row)(5-col)(64-63);
            TRUNCATED_out_REG(row-1)(col-1)(58)<=Keccak_State_S(5-row)(5-col)(64-62);
            TRUNCATED_out_REG(row-1)(col-1)(59)<=Keccak_State_S(5-row)(5-col)(64-61);
            TRUNCATED_out_REG(row-1)(col-1)(60)<=Keccak_State_S(5-row)(5-col)(64-60);
            TRUNCATED_out_REG(row-1)(col-1)(61)<=Keccak_State_S(5-row)(5-col)(64-59);
            TRUNCATED_out_REG(row-1)(col-1)(62)<=Keccak_State_S(5-row)(5-col)(64-58);
            TRUNCATED_out_REG(row-1)(col-1)(63)<=Keccak_State_S(5-row)(5-col)(64-57);

        end generate;
    end generate;



    SHA3_OUT_00: for i in 0 to 63 generate
        TRUNC_out(i) <= TRUNCATED_out_REG(1)(4)(i);
    end generate;

    SHA3_OUT_01: for row in 1 to 3 generate
        SHA3_OUT_02: for col in 1 to 5 generate
            SHA3_OUT_03: for i in 0 to 63 generate
                TRUNC_out(64+320*(3-row)+64*(5-col)+i) <= TRUNCATED_out_REG(5-row)(5-col)(i);
            end generate;
        end generate;
    end generate;

end architecture RTL;