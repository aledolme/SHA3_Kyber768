library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ACQUISITION_BLOCK is
    port(
        AB_CLK : in std_logic;
        AB_RST_N : in std_logic;
        AB_START: in std_logic;
        AB_MODE: in std_logic_vector(1 downto 0); --00 SHA3-256, 01 SHA3-512, 10 SHAKE128 and 11 SHAKE256
        AB_OP: in std_logic_vector(1 downto 0);
        AB_INPUT_BUFFER: in std_logic_vector(63 downto 0);
        AB_ready: out std_logic;  --BUFFER FULL
        AB_OUT: out std_logic_vector(1087 downto 0);
        AB_done: out std_logic
    );
end entity ACQUISITION_BLOCK;


architecture RTL of ACQUISITION_BLOCK is

    component counter_8bit
        port(
            counter_8bit_rst_n, counter_8bit_clk, counter_8bit_en : in  std_logic;
            counter_8bit_out                                      : out std_logic_vector(7 downto 0)
        );
    end component counter_8bit;

    component flipflop_rst_n
        port(
            D     : in  std_logic;
            clk   : in  std_logic;
            rst_n : in  std_logic;
            Q     : out std_logic
        );
    end component flipflop_rst_n;

    component flipflop
        port(
            D   : in  std_logic;
            clk : in  std_logic;
            Q   : out std_logic
        );
    end component flipflop;

    component COMPARATOR_EQ
        generic(N : positive := 8);
        port(
            COMPARATOR_EQ_IN0 : in  std_logic_vector(N - 1 downto 0);
            COMPARATOR_EQ_IN1 : in  std_logic_vector(N - 1 downto 0);
            COMPARATOR_EQ_OUT : out std_logic
        );
    end component COMPARATOR_EQ;

    component IN_BUFF_MEM
        generic(
            data_length    : positive := 8;
            address_length : positive := 3
        );
        port(
            IB_MEM_IN_CLK     : in  std_logic;
            IB_MEM_IN_ADDRESS : in  std_logic_vector(address_length - 1 downto 0);
            IB_MEM_OUT        : out std_logic_vector(data_length - 1 downto 0)
        );
    end component IN_BUFF_MEM;

    component IN_BUFFER
    	port(
    		IN_BUFFER_CLK    : in  std_logic;
    		IN_BUFFER_RST_N  : in  std_logic;
    		IN_BUFFER_EN     : in  std_logic;
    		IN_BUFFER_INPUT  : in  std_logic_vector(63 downto 0);
    		IN_BUFFER_OUTPUT : out std_logic_vector(1087 downto 0)
    	);
    end component IN_BUFFER;

    component counter_5bit
        port(
            counter_5bit_rst_n, counter_5bit_clk, counter_5bit_en : in  std_logic;
            counter_5bit_out                                      : out std_logic_vector(4 downto 0)
        );
    end component counter_5bit;

    component r_MEM
        generic(
            data_length    : positive := 5;
            address_length : positive := 2
        );
        port(
            r_MEM_IN_CLK     : in  std_logic;
            r_MEM_IN_ADDRESS : in  std_logic_vector(address_length - 1 downto 0);
            r_MEM_OUT        : out std_logic_vector(data_length - 1 downto 0)
        );
    end component r_MEM;
    
    component reg_en_rst_n
        generic(N : positive := 32);
        port(
            D     : in  std_logic_vector(N - 1 downto 0);
            en    : in  std_logic;
            rst_n : in  std_logic;
            clk   : in  std_logic;
            Q     : out std_logic_vector(N - 1 downto 0)
        );
    end component reg_en_rst_n;

    --conter A signals
    signal count_A_out: std_logic_vector(7 downto 0);
    signal count_A_rst_n, count_A_en: std_logic;
    signal AB_end: std_logic;

    signal BUFFER_enable: std_logic;

    --IN_BUF_MEM signal
    signal in_mem_address: std_logic_vector(3 downto 0);
    signal IB_mem_out: std_logic_vector(7 downto 0);

    --IN_BUFFER signals
    signal BUFFER_OUT: std_logic_vector(1087 downto 0);

    --conter B signals
    signal count_B_out: std_logic_vector(4 downto 0);
    signal count_B_rst_n, count_B_en: std_logic;

    signal is_ready, not_is_ready: std_logic;
    signal r_MEM_out: std_logic_vector(4 downto 0);
    signal en_AB_OUT_reg: std_logic;




    TYPE state IS (IDLE, R_STREAM, WAITING, PROCESSING, DONE);
    SIGNAL y: state;

begin


    --counter needed to understand when the complete input has been acquired
    i_countA: counter_8bit
        port map(
            counter_8bit_rst_n => count_A_rst_n,
            counter_8bit_clk   => AB_CLK,
            counter_8bit_en => count_A_en,
            counter_8bit_out   => count_A_out
        );

    in_mem_address <= AB_MODE & AB_OP;
    
    i_IN_BUF_MEM: IN_BUFF_MEM
        generic map(
            data_length    => 8,
            address_length => 4
        )
        port map(
            IB_MEM_IN_CLK     => AB_CLK,
            IB_MEM_IN_ADDRESS => in_mem_address ,
            IB_MEM_OUT        => IB_mem_out
        );

    i_comparator: COMPARATOR_EQ
        generic map(
            N => 8
        )
        port map(
            COMPARATOR_EQ_IN0 => count_A_out,
            COMPARATOR_EQ_IN1 => IB_mem_out,
            COMPARATOR_EQ_OUT => AB_end
        );

    AB_done <= AB_end;

    i_BUFFER: IN_BUFFER
        port map(
            IN_BUFFER_CLK        => AB_CLK,
            IN_BUFFER_RST_N      => AB_RST_N,
            IN_BUFFER_EN         => BUFFER_enable,
            IN_BUFFER_INPUT      => AB_INPUT_BUFFER,
            IN_BUFFER_OUTPUT     => BUFFER_OUT
        );
        
    i_reg_AB_OUT: reg_en_rst_n
        generic map(
            N => 1088
        )
        port map(
            D     => BUFFER_OUT,
            en    => en_AB_OUT_reg,
            rst_n => AB_RST_N,
            clk   => AB_CLK,
            Q     => AB_OUT
        );

    i_countB: counter_5bit
        port map(
            counter_5bit_rst_n => count_B_rst_n,
            counter_5bit_clk   => AB_CLK,
            counter_5bit_en    => count_B_en,
            counter_5bit_out   => count_B_out
        );

    i_COMPB: component COMPARATOR_EQ
        generic map(
            N => 5
        )
        port map(
            COMPARATOR_EQ_IN0 => count_B_out,
            COMPARATOR_EQ_IN1 => r_MEM_out,
            COMPARATOR_EQ_OUT => not_is_ready
        );

    is_ready <= NOT not_is_ready AND NOT AB_end;
    AB_ready <= NOT is_ready;


    i_r_MEM: r_MEM
        generic map(
            data_length    => 5,
            address_length => 2
        )
        port map(
            r_MEM_IN_CLK     => AB_CLK,
            r_MEM_IN_ADDRESS => AB_MODE,
            r_MEM_OUT        => r_MEM_out
        );


    ----------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------

    main: process (AB_CLK, AB_RST_N)
    begin  -- process
        if AB_RST_N = '0' then -- asynchronous reset (active low)

            y <= IDLE;

            --INITIALIZATION
            count_A_rst_n <= '0';
            count_B_rst_n <= '0';
            BUFFER_enable <= '0';

        elsif AB_CLK'event and AB_CLK = '1' then  -- rising clock edge
            case y is

                when IDLE =>

                    if (AB_START = '1') then

                        y <= R_STREAM;

                        count_B_en<='1';
                        count_A_en<='1';
                        count_A_rst_n <= '1';
                        count_B_rst_n <= '1';
                        BUFFER_enable <= '1';

                    else
                        y <= IDLE;
                    end if;


                when R_STREAM =>

                    if is_ready='1' then --not collected i-th r-bit stream
                        y <= R_STREAM;
                        BUFFER_enable<='1';
                        count_A_en<='1';

                    else

                        y <= WAITING; --collected N-bit stream
                        BUFFER_enable<='0';
                         en_AB_OUT_reg <='1';
                        count_B_rst_n <= '0';
                        count_A_en<='0';

                    end if;

                    if AB_end='1' then
                        y <= DONE;
                        en_AB_OUT_reg <='1';
                        count_A_rst_n <= '0';
                        count_B_rst_n <= '0';
                    end if;

                when WAITING =>

                    --AB_OUT <= BUFFER_OUT;
                     en_AB_OUT_reg <='0';

                    y <= PROCESSING;

                when PROCESSING =>

                    y <= R_STREAM;

                    count_B_rst_n <= '1';
                    count_A_en <='0';
                    BUFFER_enable <= '1';

                when DONE => -- @suppress "Dead state 'DONE': state does not have outgoing transitions"

                    --AB_OUT <= BUFFER_OUT;
                    en_AB_OUT_reg <='0';
                    null;


            end case;
        end if;
    end process;

end architecture RTL;