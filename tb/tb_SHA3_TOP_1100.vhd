library ieee;
library std;
use std.textio.all;

use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity tb_SHA3_TOP_1100 is
end entity tb_SHA3_TOP_1100;

architecture testbench of tb_SHA3_TOP_1100 is

    component SHA3_TOP
    	port(
    		SHA3_TOP_CLK   : IN  std_logic;
    		SHA3_TOP_RST_N : IN  std_logic;
    		SHA3_TOP_START : IN  std_logic;
    		SHA3_TOP_MODE  : IN  std_logic_vector(1 downto 0);
    		SHA3_TOP_OP    : IN  std_logic_vector(1 downto 0);
    		SHA3_TOP_INPUT : IN  std_logic_vector(63 downto 0);
    		SHA3_AB_READY  : OUT std_logic;
    		SHA3_AB_DONE   : OUT std_logic;
    		SHA3_TOP_READY : OUT std_logic;
    		SHA3_TOP_end   : OUT std_logic;
    		SHA3_TOP_DONE  : OUT std_logic;
    		SHA3_TOP_OUT   : OUT std_logic_vector (63 downto 0)
    	);
    end component SHA3_TOP;

    signal CLK : std_logic;
    signal RST_N, SHA3_TOP_START : std_logic;
    signal SHA3_TOP_MODE: std_logic_vector(1 downto 0);
    signal SHA3_TOP_OP: std_logic_vector(1 downto 0);
    signal SHA3_TOP_INPUT: std_logic_vector(63 downto 0);
    --------------------------------------------------------
    signal AB_READY, AB_DONE: std_logic;


    ------------------------------------------------------------------
    signal SHA3_DONE, SHA3_TOP_READY,SHA3_end: std_logic;
    signal SHA3_OUT: std_logic_vector(63 downto 0);

    type st_type is (INIT,INIT2, read_first_input, WAITING, WAITING2,WAITING3, END_HASH1, STOP, DONE);
    type out_type is (CHECK);
    signal st : st_type;
    signal st_out : out_type;

begin

    RST_N <= '0', '1' after 19 ns;
    SHA3_TOP_MODE <= "11";
    SHA3_TOP_OP <= "00";

    clock_driver : process
        constant period : time := 10 ns;
    begin
        CLK <= '0';
        wait for period / 2;
        CLK <= '1';
        wait for period / 2;
    end process clock_driver;



    p_main: process (CLK,RST_N)
        variable line_in : line;
        variable temp: std_logic_vector(63 downto 0);
        file filein : text open read_mode is "./txt_files/SHA3_IN_1100.txt";
        file fileout : text open write_mode is "./txt_files/SHA3_OUT_1100.txt";
    begin
        if RST_N = '0' then                 -- asynchronous rst_n (active low)
            st <= INIT;

        elsif CLK'event and CLK = '1' then  -- rising clk edge
            case st is
                when INIT =>

                    SHA3_TOP_START<='1';
                    st <= INIT2;

                when INIT2 =>

                    if(SHA3_TOP_START='1') then
                        st<=read_first_input;
                    else
                        st<=INIT2;
                    end if;

                when read_first_input =>

                    readline(filein,line_in);

                    if(line_in(1)='.') then
                        st <= STOP;
                        SHA3_TOP_START<='0';
                    else
                        if (AB_READY='1' AND AB_DONE='0') then
                            st<=WAITING;

                        elsif (AB_DONE='1') then
                            st<= WAITING2;

                        else
                            hread(line_in,temp);
                            SHA3_TOP_INPUT<=temp;
                            st<=read_first_input;
                        end if;
                    end if;

                when WAITING =>

                    st <= END_HASH1;

                when WAITING2 =>

                    st <= STOP;

                when WAITING3 =>

                    st <= STOP;

                when END_HASH1 =>

                    if(SHA3_DONE='0') then
                        st <= read_first_input;
                        SHA3_TOP_START<='1';
                    end if;

                when STOP =>


                    SHA3_TOP_START<='0';

                    FILE_CLOSE(filein);
                    FILE_CLOSE(fileout);
                    
                    if (SHA3_DONE ='1') then
                        st <= DONE;
                    end if;
                    
                when DONE => -- @suppress "Dead state 'DONE': state does not have outgoing transitions"
                    assert false report "Simulation completed" severity failure;
                    
            end case;

        end if;
    end process;


    output_main: process (CLK,RST_N)
        variable line_out : line;
        variable temp: std_logic_vector(63 downto 0);
        file fileout : text open write_mode is "./txt_files/SHA3_OUT_1100.txt";
    begin
        if RST_N = '0' then                 -- asynchronous rst_n (active low)
            st_out <= CHECK;
        elsif CLK'event and CLK = '1' then  -- rising clk edge
            case st_out is
                when CHECK =>
                    if SHA3_DONE = '1' then
                        write(line_out, string'("-"));
                        writeline(fileout, line_out);
                    elsif SHA3_end='1' then
                        temp:=SHA3_OUT;
                        hwrite(line_out,temp);
                        writeline(fileout,line_out);
                    end if;

            end case;

        end if;
    end process;

    i_SHA3: SHA3_TOP
        port map(
            SHA3_TOP_CLK     => CLK,
            SHA3_TOP_RST_N   => RST_N,
            SHA3_TOP_START   => SHA3_TOP_START,
            SHA3_TOP_MODE    => SHA3_TOP_MODE,
            SHA3_TOP_OP      => SHA3_TOP_OP,
            SHA3_TOP_INPUT   => SHA3_TOP_INPUT,
            SHA3_AB_READY    => AB_READY,
            SHA3_AB_DONE     => AB_DONE,
            SHA3_TOP_READY => SHA3_TOP_READY,
            SHA3_TOP_end => SHA3_end,
            SHA3_TOP_DONE => SHA3_DONE,
            SHA3_TOP_OUT => SHA3_OUT
        );


end architecture testbench;