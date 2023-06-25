LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adder IS
    PORT
(
        a, b:  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        cin, en, clk: IN STD_LOGIC;
        s: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        cout: OUT  STD_LOGIC
    );
END adder;

ARCHITECTURE behavior OF adder IS

    SIGNAL    s_aux: STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL    g: STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL    p: STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL    carry: STD_LOGIC_VECTOR(4 DOWNTO 1);

BEGIN
    s_aux <= a XOR b;
    g <= a AND b;
    p <= a OR b;

    PROCESS (g,p,carry, cin)
    BEGIN
        carry(1) <= g(0) OR (p(0) AND cin);
        inst: FOR i IN 1 TO 3 LOOP
            carry(i+1) <= g(i) OR (p(i) AND carry(i));
        END LOOP;
        cout <= g(3) OR (p(3) AND carry(3));
    END PROCESS;
    
    s(0) <= s_aux(0) XOR cin;
    s(4 DOWNTO 1) <= s_aux(4 DOWNTO 1) XOR carry(4 DOWNTO 1);


END behavior;