library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PAD_SHA3_512 is
    port(
        PADD_SHA3_IN_512 : in std_logic_vector(511 downto 0);
        PADD_SHA3_OP: in std_logic_vector(1 downto 0);
        PADD_SHA3_OUT_512 : out k_state
    );
end entity PAD_SHA3_512;

architecture RTL of PAD_SHA3_512 is

    component Keccak_2to1mux
        port(
            x      : in  k_state;
            y      : in  k_state;
            s      : in  std_logic;
            output : out k_state
        );
    end component Keccak_2to1mux;

    signal PADD_SHA3_IN_512_00: k_state;
    signal PADD_SHA3_IN_512_01: k_state;
    signal PADD_SHA3_IN_512_10: k_state;
    signal output_mux1: k_state;


begin

    --SHAE_OP=00
    --PADDING FOR SHA3_512(d)
    padd: for i in 1 to 4 generate

        PADD_SHA3_IN_512_00(0)(4-i)(0)<=PADD_SHA3_IN_512(64*i-8);
        PADD_SHA3_IN_512_00(0)(4-i)(1)<=PADD_SHA3_IN_512(64*i-7);
        PADD_SHA3_IN_512_00(0)(4-i)(2)<=PADD_SHA3_IN_512(64*i-6);
        PADD_SHA3_IN_512_00(0)(4-i)(3)<=PADD_SHA3_IN_512(64*i-5);
        PADD_SHA3_IN_512_00(0)(4-i)(4)<=PADD_SHA3_IN_512(64*i-4);
        PADD_SHA3_IN_512_00(0)(4-i)(5)<=PADD_SHA3_IN_512(64*i-3);
        PADD_SHA3_IN_512_00(0)(4-i)(6)<=PADD_SHA3_IN_512(64*i-2);
        PADD_SHA3_IN_512_00(0)(4-i)(7)<=PADD_SHA3_IN_512(64*i-1);

        PADD_SHA3_IN_512_00(0)(4-i)(8)<=PADD_SHA3_IN_512(64*i-16);
        PADD_SHA3_IN_512_00(0)(4-i)(9)<=PADD_SHA3_IN_512(64*i-15);
        PADD_SHA3_IN_512_00(0)(4-i)(10)<=PADD_SHA3_IN_512(64*i-14);
        PADD_SHA3_IN_512_00(0)(4-i)(11)<=PADD_SHA3_IN_512(64*i-13);
        PADD_SHA3_IN_512_00(0)(4-i)(12)<=PADD_SHA3_IN_512(64*i-12);
        PADD_SHA3_IN_512_00(0)(4-i)(13)<=PADD_SHA3_IN_512(64*i-11);
        PADD_SHA3_IN_512_00(0)(4-i)(14)<=PADD_SHA3_IN_512(64*i-10);
        PADD_SHA3_IN_512_00(0)(4-i)(15)<=PADD_SHA3_IN_512(64*i-9);

        PADD_SHA3_IN_512_00(0)(4-i)(16)<=PADD_SHA3_IN_512(64*i-24);
        PADD_SHA3_IN_512_00(0)(4-i)(17)<=PADD_SHA3_IN_512(64*i-23);
        PADD_SHA3_IN_512_00(0)(4-i)(18)<=PADD_SHA3_IN_512(64*i-22);
        PADD_SHA3_IN_512_00(0)(4-i)(19)<=PADD_SHA3_IN_512(64*i-21);
        PADD_SHA3_IN_512_00(0)(4-i)(20)<=PADD_SHA3_IN_512(64*i-20);
        PADD_SHA3_IN_512_00(0)(4-i)(21)<=PADD_SHA3_IN_512(64*i-19);
        PADD_SHA3_IN_512_00(0)(4-i)(22)<=PADD_SHA3_IN_512(64*i-18);
        PADD_SHA3_IN_512_00(0)(4-i)(23)<=PADD_SHA3_IN_512(64*i-17);

        PADD_SHA3_IN_512_00(0)(4-i)(24)<=PADD_SHA3_IN_512(64*i-32);
        PADD_SHA3_IN_512_00(0)(4-i)(25)<=PADD_SHA3_IN_512(64*i-31);
        PADD_SHA3_IN_512_00(0)(4-i)(26)<=PADD_SHA3_IN_512(64*i-30);
        PADD_SHA3_IN_512_00(0)(4-i)(27)<=PADD_SHA3_IN_512(64*i-29);
        PADD_SHA3_IN_512_00(0)(4-i)(28)<=PADD_SHA3_IN_512(64*i-28);
        PADD_SHA3_IN_512_00(0)(4-i)(29)<=PADD_SHA3_IN_512(64*i-27);
        PADD_SHA3_IN_512_00(0)(4-i)(30)<=PADD_SHA3_IN_512(64*i-26);
        PADD_SHA3_IN_512_00(0)(4-i)(31)<=PADD_SHA3_IN_512(64*i-25);

        PADD_SHA3_IN_512_00(0)(4-i)(32)<=PADD_SHA3_IN_512(64*i-40);
        PADD_SHA3_IN_512_00(0)(4-i)(33)<=PADD_SHA3_IN_512(64*i-39);
        PADD_SHA3_IN_512_00(0)(4-i)(34)<=PADD_SHA3_IN_512(64*i-38);
        PADD_SHA3_IN_512_00(0)(4-i)(35)<=PADD_SHA3_IN_512(64*i-37);
        PADD_SHA3_IN_512_00(0)(4-i)(36)<=PADD_SHA3_IN_512(64*i-36);
        PADD_SHA3_IN_512_00(0)(4-i)(37)<=PADD_SHA3_IN_512(64*i-35);
        PADD_SHA3_IN_512_00(0)(4-i)(38)<=PADD_SHA3_IN_512(64*i-34);
        PADD_SHA3_IN_512_00(0)(4-i)(39)<=PADD_SHA3_IN_512(64*i-33);

        PADD_SHA3_IN_512_00(0)(4-i)(40)<=PADD_SHA3_IN_512(64*i-48);
        PADD_SHA3_IN_512_00(0)(4-i)(41)<=PADD_SHA3_IN_512(64*i-47);
        PADD_SHA3_IN_512_00(0)(4-i)(42)<=PADD_SHA3_IN_512(64*i-46);
        PADD_SHA3_IN_512_00(0)(4-i)(43)<=PADD_SHA3_IN_512(64*i-45);
        PADD_SHA3_IN_512_00(0)(4-i)(44)<=PADD_SHA3_IN_512(64*i-44);
        PADD_SHA3_IN_512_00(0)(4-i)(45)<=PADD_SHA3_IN_512(64*i-43);
        PADD_SHA3_IN_512_00(0)(4-i)(46)<=PADD_SHA3_IN_512(64*i-42);
        PADD_SHA3_IN_512_00(0)(4-i)(47)<=PADD_SHA3_IN_512(64*i-41);

        PADD_SHA3_IN_512_00(0)(4-i)(48)<=PADD_SHA3_IN_512(64*i-56);
        PADD_SHA3_IN_512_00(0)(4-i)(49)<=PADD_SHA3_IN_512(64*i-55);
        PADD_SHA3_IN_512_00(0)(4-i)(50)<=PADD_SHA3_IN_512(64*i-54);
        PADD_SHA3_IN_512_00(0)(4-i)(51)<=PADD_SHA3_IN_512(64*i-53);
        PADD_SHA3_IN_512_00(0)(4-i)(52)<=PADD_SHA3_IN_512(64*i-52);
        PADD_SHA3_IN_512_00(0)(4-i)(53)<=PADD_SHA3_IN_512(64*i-51);
        PADD_SHA3_IN_512_00(0)(4-i)(54)<=PADD_SHA3_IN_512(64*i-50);
        PADD_SHA3_IN_512_00(0)(4-i)(55)<=PADD_SHA3_IN_512(64*i-49);

        PADD_SHA3_IN_512_00(0)(4-i)(56)<=PADD_SHA3_IN_512(64*i-64);
        PADD_SHA3_IN_512_00(0)(4-i)(57)<=PADD_SHA3_IN_512(64*i-63);
        PADD_SHA3_IN_512_00(0)(4-i)(58)<=PADD_SHA3_IN_512(64*i-62);
        PADD_SHA3_IN_512_00(0)(4-i)(59)<=PADD_SHA3_IN_512(64*i-61);
        PADD_SHA3_IN_512_00(0)(4-i)(60)<=PADD_SHA3_IN_512(64*i-60);
        PADD_SHA3_IN_512_00(0)(4-i)(61)<=PADD_SHA3_IN_512(64*i-59);
        PADD_SHA3_IN_512_00(0)(4-i)(62)<=PADD_SHA3_IN_512(64*i-58);
        PADD_SHA3_IN_512_00(0)(4-i)(63)<=PADD_SHA3_IN_512(64*i-57);


    end generate;


    PADD_SHA3_IN_512_00(0)(4) <= "0000000000000000000000000000000000000000000000000000000000000110";

    PADD_SHA3_IN_512_00(1)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(2)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(3)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(4)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_00(1)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(2)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(3)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(4)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_00(1)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(2)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(3)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(4)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_00(1)(3) <= "1000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(2)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(3)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(4)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_00(1)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(2)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(3)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_00(4)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";



    --SHAE_OP=01
    --SHA3_512(m||H(pk))
    padd_512b1: for i in 1 to 5 generate
        PADD_SHA3_IN_512_01(0)(5-i)(0)<=PADD_SHA3_IN_512(192+64*i-8);
        PADD_SHA3_IN_512_01(0)(5-i)(1)<=PADD_SHA3_IN_512(192+64*i-7);
        PADD_SHA3_IN_512_01(0)(5-i)(2)<=PADD_SHA3_IN_512(192+64*i-6);
        PADD_SHA3_IN_512_01(0)(5-i)(3)<=PADD_SHA3_IN_512(192+64*i-5);
        PADD_SHA3_IN_512_01(0)(5-i)(4)<=PADD_SHA3_IN_512(192+64*i-4);
        PADD_SHA3_IN_512_01(0)(5-i)(5)<=PADD_SHA3_IN_512(192+64*i-3);
        PADD_SHA3_IN_512_01(0)(5-i)(6)<=PADD_SHA3_IN_512(192+64*i-2);
        PADD_SHA3_IN_512_01(0)(5-i)(7)<=PADD_SHA3_IN_512(192+64*i-1);

        PADD_SHA3_IN_512_01(0)(5-i)(8)<=PADD_SHA3_IN_512(192+64*i-16);
        PADD_SHA3_IN_512_01(0)(5-i)(9)<=PADD_SHA3_IN_512(192+64*i-15);
        PADD_SHA3_IN_512_01(0)(5-i)(10)<=PADD_SHA3_IN_512(192+64*i-14);
        PADD_SHA3_IN_512_01(0)(5-i)(11)<=PADD_SHA3_IN_512(192+64*i-13);
        PADD_SHA3_IN_512_01(0)(5-i)(12)<=PADD_SHA3_IN_512(192+64*i-12);
        PADD_SHA3_IN_512_01(0)(5-i)(13)<=PADD_SHA3_IN_512(192+64*i-11);
        PADD_SHA3_IN_512_01(0)(5-i)(14)<=PADD_SHA3_IN_512(192+64*i-10);
        PADD_SHA3_IN_512_01(0)(5-i)(15)<=PADD_SHA3_IN_512(192+64*i-9);

        PADD_SHA3_IN_512_01(0)(5-i)(16)<=PADD_SHA3_IN_512(192+64*i-24);
        PADD_SHA3_IN_512_01(0)(5-i)(17)<=PADD_SHA3_IN_512(192+64*i-23);
        PADD_SHA3_IN_512_01(0)(5-i)(18)<=PADD_SHA3_IN_512(192+64*i-22);
        PADD_SHA3_IN_512_01(0)(5-i)(19)<=PADD_SHA3_IN_512(192+64*i-21);
        PADD_SHA3_IN_512_01(0)(5-i)(20)<=PADD_SHA3_IN_512(192+64*i-20);
        PADD_SHA3_IN_512_01(0)(5-i)(21)<=PADD_SHA3_IN_512(192+64*i-19);
        PADD_SHA3_IN_512_01(0)(5-i)(22)<=PADD_SHA3_IN_512(192+64*i-18);
        PADD_SHA3_IN_512_01(0)(5-i)(23)<=PADD_SHA3_IN_512(192+64*i-17);

        PADD_SHA3_IN_512_01(0)(5-i)(24)<=PADD_SHA3_IN_512(192+64*i-32);
        PADD_SHA3_IN_512_01(0)(5-i)(25)<=PADD_SHA3_IN_512(192+64*i-31);
        PADD_SHA3_IN_512_01(0)(5-i)(26)<=PADD_SHA3_IN_512(192+64*i-30);
        PADD_SHA3_IN_512_01(0)(5-i)(27)<=PADD_SHA3_IN_512(192+64*i-29);
        PADD_SHA3_IN_512_01(0)(5-i)(28)<=PADD_SHA3_IN_512(192+64*i-28);
        PADD_SHA3_IN_512_01(0)(5-i)(29)<=PADD_SHA3_IN_512(192+64*i-27);
        PADD_SHA3_IN_512_01(0)(5-i)(30)<=PADD_SHA3_IN_512(192+64*i-26);
        PADD_SHA3_IN_512_01(0)(5-i)(31)<=PADD_SHA3_IN_512(192+64*i-25);

        PADD_SHA3_IN_512_01(0)(5-i)(32)<=PADD_SHA3_IN_512(192+64*i-40);
        PADD_SHA3_IN_512_01(0)(5-i)(33)<=PADD_SHA3_IN_512(192+64*i-39);
        PADD_SHA3_IN_512_01(0)(5-i)(34)<=PADD_SHA3_IN_512(192+64*i-38);
        PADD_SHA3_IN_512_01(0)(5-i)(35)<=PADD_SHA3_IN_512(192+64*i-37);
        PADD_SHA3_IN_512_01(0)(5-i)(36)<=PADD_SHA3_IN_512(192+64*i-36);
        PADD_SHA3_IN_512_01(0)(5-i)(37)<=PADD_SHA3_IN_512(192+64*i-35);
        PADD_SHA3_IN_512_01(0)(5-i)(38)<=PADD_SHA3_IN_512(192+64*i-34);
        PADD_SHA3_IN_512_01(0)(5-i)(39)<=PADD_SHA3_IN_512(192+64*i-33);

        PADD_SHA3_IN_512_01(0)(5-i)(40)<=PADD_SHA3_IN_512(192+64*i-48);
        PADD_SHA3_IN_512_01(0)(5-i)(41)<=PADD_SHA3_IN_512(192+64*i-47);
        PADD_SHA3_IN_512_01(0)(5-i)(42)<=PADD_SHA3_IN_512(192+64*i-46);
        PADD_SHA3_IN_512_01(0)(5-i)(43)<=PADD_SHA3_IN_512(192+64*i-45);
        PADD_SHA3_IN_512_01(0)(5-i)(44)<=PADD_SHA3_IN_512(192+64*i-44);
        PADD_SHA3_IN_512_01(0)(5-i)(45)<=PADD_SHA3_IN_512(192+64*i-43);
        PADD_SHA3_IN_512_01(0)(5-i)(46)<=PADD_SHA3_IN_512(192+64*i-42);
        PADD_SHA3_IN_512_01(0)(5-i)(47)<=PADD_SHA3_IN_512(192+64*i-41);

        PADD_SHA3_IN_512_01(0)(5-i)(48)<=PADD_SHA3_IN_512(192+64*i-56);
        PADD_SHA3_IN_512_01(0)(5-i)(49)<=PADD_SHA3_IN_512(192+64*i-55);
        PADD_SHA3_IN_512_01(0)(5-i)(50)<=PADD_SHA3_IN_512(192+64*i-54);
        PADD_SHA3_IN_512_01(0)(5-i)(51)<=PADD_SHA3_IN_512(192+64*i-53);
        PADD_SHA3_IN_512_01(0)(5-i)(52)<=PADD_SHA3_IN_512(192+64*i-52);
        PADD_SHA3_IN_512_01(0)(5-i)(53)<=PADD_SHA3_IN_512(192+64*i-51);
        PADD_SHA3_IN_512_01(0)(5-i)(54)<=PADD_SHA3_IN_512(192+64*i-50);
        PADD_SHA3_IN_512_01(0)(5-i)(55)<=PADD_SHA3_IN_512(192+64*i-49);

        PADD_SHA3_IN_512_01(0)(5-i)(56)<=PADD_SHA3_IN_512(192+64*i-64);
        PADD_SHA3_IN_512_01(0)(5-i)(57)<=PADD_SHA3_IN_512(192+64*i-63);
        PADD_SHA3_IN_512_01(0)(5-i)(58)<=PADD_SHA3_IN_512(192+64*i-62);
        PADD_SHA3_IN_512_01(0)(5-i)(59)<=PADD_SHA3_IN_512(192+64*i-61);
        PADD_SHA3_IN_512_01(0)(5-i)(60)<=PADD_SHA3_IN_512(192+64*i-60);
        PADD_SHA3_IN_512_01(0)(5-i)(61)<=PADD_SHA3_IN_512(192+64*i-59);
        PADD_SHA3_IN_512_01(0)(5-i)(62)<=PADD_SHA3_IN_512(192+64*i-58);
        PADD_SHA3_IN_512_01(0)(5-i)(63)<=PADD_SHA3_IN_512(192+64*i-57);
    end generate;

    padd_512b2: for i in 1 to 3 generate
        PADD_SHA3_IN_512_01(1)(3-i)(0)<=PADD_SHA3_IN_512(64*i-8);
        PADD_SHA3_IN_512_01(1)(3-i)(1)<=PADD_SHA3_IN_512(64*i-7);
        PADD_SHA3_IN_512_01(1)(3-i)(2)<=PADD_SHA3_IN_512(64*i-6);
        PADD_SHA3_IN_512_01(1)(3-i)(3)<=PADD_SHA3_IN_512(64*i-5);
        PADD_SHA3_IN_512_01(1)(3-i)(4)<=PADD_SHA3_IN_512(64*i-4);
        PADD_SHA3_IN_512_01(1)(3-i)(5)<=PADD_SHA3_IN_512(64*i-3);
        PADD_SHA3_IN_512_01(1)(3-i)(6)<=PADD_SHA3_IN_512(64*i-2);
        PADD_SHA3_IN_512_01(1)(3-i)(7)<=PADD_SHA3_IN_512(64*i-1);

        PADD_SHA3_IN_512_01(1)(3-i)(8)<=PADD_SHA3_IN_512(64*i-16);
        PADD_SHA3_IN_512_01(1)(3-i)(9)<=PADD_SHA3_IN_512(64*i-15);
        PADD_SHA3_IN_512_01(1)(3-i)(10)<=PADD_SHA3_IN_512(64*i-14);
        PADD_SHA3_IN_512_01(1)(3-i)(11)<=PADD_SHA3_IN_512(64*i-13);
        PADD_SHA3_IN_512_01(1)(3-i)(12)<=PADD_SHA3_IN_512(64*i-12);
        PADD_SHA3_IN_512_01(1)(3-i)(13)<=PADD_SHA3_IN_512(64*i-11);
        PADD_SHA3_IN_512_01(1)(3-i)(14)<=PADD_SHA3_IN_512(64*i-10);
        PADD_SHA3_IN_512_01(1)(3-i)(15)<=PADD_SHA3_IN_512(64*i-9);

        PADD_SHA3_IN_512_01(1)(3-i)(16)<=PADD_SHA3_IN_512(64*i-24);
        PADD_SHA3_IN_512_01(1)(3-i)(17)<=PADD_SHA3_IN_512(64*i-23);
        PADD_SHA3_IN_512_01(1)(3-i)(18)<=PADD_SHA3_IN_512(64*i-22);
        PADD_SHA3_IN_512_01(1)(3-i)(19)<=PADD_SHA3_IN_512(64*i-21);
        PADD_SHA3_IN_512_01(1)(3-i)(20)<=PADD_SHA3_IN_512(64*i-20);
        PADD_SHA3_IN_512_01(1)(3-i)(21)<=PADD_SHA3_IN_512(64*i-19);
        PADD_SHA3_IN_512_01(1)(3-i)(22)<=PADD_SHA3_IN_512(64*i-18);
        PADD_SHA3_IN_512_01(1)(3-i)(23)<=PADD_SHA3_IN_512(64*i-17);

        PADD_SHA3_IN_512_01(1)(3-i)(24)<=PADD_SHA3_IN_512(64*i-32);
        PADD_SHA3_IN_512_01(1)(3-i)(25)<=PADD_SHA3_IN_512(64*i-31);
        PADD_SHA3_IN_512_01(1)(3-i)(26)<=PADD_SHA3_IN_512(64*i-30);
        PADD_SHA3_IN_512_01(1)(3-i)(27)<=PADD_SHA3_IN_512(64*i-29);
        PADD_SHA3_IN_512_01(1)(3-i)(28)<=PADD_SHA3_IN_512(64*i-28);
        PADD_SHA3_IN_512_01(1)(3-i)(29)<=PADD_SHA3_IN_512(64*i-27);
        PADD_SHA3_IN_512_01(1)(3-i)(30)<=PADD_SHA3_IN_512(64*i-26);
        PADD_SHA3_IN_512_01(1)(3-i)(31)<=PADD_SHA3_IN_512(64*i-25);

        PADD_SHA3_IN_512_01(1)(3-i)(32)<=PADD_SHA3_IN_512(64*i-40);
        PADD_SHA3_IN_512_01(1)(3-i)(33)<=PADD_SHA3_IN_512(64*i-39);
        PADD_SHA3_IN_512_01(1)(3-i)(34)<=PADD_SHA3_IN_512(64*i-38);
        PADD_SHA3_IN_512_01(1)(3-i)(35)<=PADD_SHA3_IN_512(64*i-37);
        PADD_SHA3_IN_512_01(1)(3-i)(36)<=PADD_SHA3_IN_512(64*i-36);
        PADD_SHA3_IN_512_01(1)(3-i)(37)<=PADD_SHA3_IN_512(64*i-35);
        PADD_SHA3_IN_512_01(1)(3-i)(38)<=PADD_SHA3_IN_512(64*i-34);
        PADD_SHA3_IN_512_01(1)(3-i)(39)<=PADD_SHA3_IN_512(64*i-33);

        PADD_SHA3_IN_512_01(1)(3-i)(40)<=PADD_SHA3_IN_512(64*i-48);
        PADD_SHA3_IN_512_01(1)(3-i)(41)<=PADD_SHA3_IN_512(64*i-47);
        PADD_SHA3_IN_512_01(1)(3-i)(42)<=PADD_SHA3_IN_512(64*i-46);
        PADD_SHA3_IN_512_01(1)(3-i)(43)<=PADD_SHA3_IN_512(64*i-45);
        PADD_SHA3_IN_512_01(1)(3-i)(44)<=PADD_SHA3_IN_512(64*i-44);
        PADD_SHA3_IN_512_01(1)(3-i)(45)<=PADD_SHA3_IN_512(64*i-43);
        PADD_SHA3_IN_512_01(1)(3-i)(46)<=PADD_SHA3_IN_512(64*i-42);
        PADD_SHA3_IN_512_01(1)(3-i)(47)<=PADD_SHA3_IN_512(64*i-41);

        PADD_SHA3_IN_512_01(1)(3-i)(48)<=PADD_SHA3_IN_512(64*i-56);
        PADD_SHA3_IN_512_01(1)(3-i)(49)<=PADD_SHA3_IN_512(64*i-55);
        PADD_SHA3_IN_512_01(1)(3-i)(50)<=PADD_SHA3_IN_512(64*i-54);
        PADD_SHA3_IN_512_01(1)(3-i)(51)<=PADD_SHA3_IN_512(64*i-53);
        PADD_SHA3_IN_512_01(1)(3-i)(52)<=PADD_SHA3_IN_512(64*i-52);
        PADD_SHA3_IN_512_01(1)(3-i)(53)<=PADD_SHA3_IN_512(64*i-51);
        PADD_SHA3_IN_512_01(1)(3-i)(54)<=PADD_SHA3_IN_512(64*i-50);
        PADD_SHA3_IN_512_01(1)(3-i)(55)<=PADD_SHA3_IN_512(64*i-49);

        PADD_SHA3_IN_512_01(1)(3-i)(56)<=PADD_SHA3_IN_512(64*i-64);
        PADD_SHA3_IN_512_01(1)(3-i)(57)<=PADD_SHA3_IN_512(64*i-63);
        PADD_SHA3_IN_512_01(1)(3-i)(58)<=PADD_SHA3_IN_512(64*i-62);
        PADD_SHA3_IN_512_01(1)(3-i)(59)<=PADD_SHA3_IN_512(64*i-61);
        PADD_SHA3_IN_512_01(1)(3-i)(60)<=PADD_SHA3_IN_512(64*i-60);
        PADD_SHA3_IN_512_01(1)(3-i)(61)<=PADD_SHA3_IN_512(64*i-59);
        PADD_SHA3_IN_512_01(1)(3-i)(62)<=PADD_SHA3_IN_512(64*i-58);
        PADD_SHA3_IN_512_01(1)(3-i)(63)<=PADD_SHA3_IN_512(64*i-57);
    end generate;


    PADD_SHA3_IN_512_01(1)(3) <= "1000000000000000000000000000000000000000000000000000000000000110";
    PADD_SHA3_IN_512_01(1)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_01(2)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(2)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(2)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(2)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(2)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_01(3)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(3)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(3)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(3)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(3)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_01(4)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(4)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(4)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(4)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_01(4)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";



    --SHA3_256(c)
    PADD_SHA3_IN_512_10(0)(0) <= "0000000000000000000000000000000000000000000000000000000000000110";
    PADD_SHA3_IN_512_10(0)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(0)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(0)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_10(0)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_10(1)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(2)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(3)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(4)(0) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_10(1)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(2)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(3)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(4)(1) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_10(1)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(2)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(3)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(4)(2) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_10(1)(3) <= "1000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(2)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(3)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(4)(3) <= "0000000000000000000000000000000000000000000000000000000000000000";

    PADD_SHA3_IN_512_10(1)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(2)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(3)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
    PADD_SHA3_IN_512_10(4)(4) <= "0000000000000000000000000000000000000000000000000000000000000000";

    i_MUX_SHA3_256: Keccak_2to1mux
        port map(
            x      => PADD_SHA3_IN_512_00,
            y      => PADD_SHA3_IN_512_01,
            s      => PADD_SHA3_OP(0),
            output => output_mux1
        );

    i_MUX_SHA3_256_2: Keccak_2to1mux
        port map(
            x      => output_mux1,
            y      => PADD_SHA3_IN_512_10,
            s      => PADD_SHA3_OP(1),
            output => PADD_SHA3_OUT_512
        );


end architecture RTL;
