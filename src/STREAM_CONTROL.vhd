library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity STREAM_CONTROL is
    port(
        SC_CLK: IN std_logic;
        SC_RST_N: IN std_logic;
        SC_START: IN std_logic;
        SC_MODE: std_logic_vector(1 downto 0);
        SC_OP: std_logic_vector(1 downto 0);
        SC_stream_in: IN std_logic_vector(1087 downto 0);
        SC_one_stream_op: in std_logic;
        SC_AB_READY:  IN std_logic;
        SC_SHA3_READY: IN std_logic;
        SC_stream_out: OUT std_logic_vector(1087 downto 0);
        SC_last_block:  OUT std_logic;
        SC_DONE: out std_logic
    );
end entity STREAM_CONTROL;

architecture RTL of STREAM_CONTROL is

    component flipflop_rst_n
        port(
            D     : in  std_logic;
            clk   : in  std_logic;
            rst_n : in  std_logic;
            Q     : out std_logic
        );
    end component flipflop_rst_n;

    component flipflop_en_rst_n
        port(
            D     : in  std_logic;
            clk   : in  std_logic;
            en    : in  std_logic;
            rst_n : in  std_logic;
            Q     : out std_logic
        );
    end component flipflop_en_rst_n;

    component counter_9bit
        port(
            counter_9bit_rst_n, counter_9bit_clk, counter_9bit_en : in  std_logic;
            counter_9bit_out                                      : out std_logic_vector(8 downto 0)
        );
    end component counter_9bit;

    component counter_5bit
        port(
            counter_5bit_rst_n, counter_5bit_clk, counter_5bit_en : in  std_logic;
            counter_5bit_out                                      : out std_logic_vector(4 downto 0)
        );
    end component counter_5bit;

    component COMPARATOR_EQ
        generic(N : positive := 32);
        port(
            COMPARATOR_EQ_IN0 : in  std_logic_vector(N - 1 downto 0);
            COMPARATOR_EQ_IN1 : in  std_logic_vector(N - 1 downto 0);
            COMPARATOR_EQ_OUT : out std_logic
        );
    end component COMPARATOR_EQ;

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

    component bN_4to1mux
        generic(N : positive := 8);
        port(
            IN_0   : in  std_logic_vector(N-1 downto 0);
            IN_1   : in  std_logic_vector(N-1 downto 0);
            IN_2   : in  std_logic_vector(N-1 downto 0);
            IN_3   : in  std_logic_vector(N-1 downto 0);
            S      : in  std_logic_vector(1 downto 0);
            OUTPUT : out std_logic_vector(N-1 downto 0)
        );
    end component bN_4to1mux;

    component bN_2to1mux
        generic(N : positive := 8);
        port(
            x, y   : in  std_logic_vector(N-1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N-1 downto 0)
        );
    end component bN_2to1mux;

    component b_2to1mux
        port(
            x, y   : in  std_logic;
            s      : in  std_logic;
            output : out std_logic
        );
    end component b_2to1mux;

    component rcycle_MEM
        port(
            rcycle_CLK            : in  std_logic;
            rcycle_MEM_IN_ADDRESS : in  std_logic_vector(3 downto 0);
            rcycle_MEM_OUT        : out std_logic_vector(4 downto 0)
        );
    end component rcycle_MEM;

    component sel_MUX_MEM
        generic(
            data_length    : positive := 5;
            address_length : positive := 6
        );
        port(
            sel_MUX_MEM_IN_CLK     : in  std_logic;
            sel_MUX_MEM_IN_ADDRESS : in  std_logic_vector(address_length - 1 downto 0);
            sel_MUX_MEM_OUT        : out std_logic_vector(data_length - 1 downto 0)
        );
    end component sel_MUX_MEM;

    component SC_SHA3_512
        port(
            SC_SHA3_512_CLK        : IN  std_logic;
            SC_SHA3_512_RST_N      : IN  std_logic;
            SC_SHA3_512_stream_in  : IN  std_logic_vector(575 downto 0);
            SC_SHA3_512_en         : IN  std_logic;
            SC_SHA3_512_mux        : IN  std_logic_vector(4 downto 0);
            SC_SHA3_512_stream_out : OUT std_logic_vector(575 downto 0)
        );
    end component SC_SHA3_512;

    component SC_SHA3_256
        port(
            SC_SHA3_256_CLK        : IN  std_logic;
            SC_SHA3_256_RST_N      : IN  std_logic;
            SC_SHA3_256_stream_in  : IN  std_logic_vector(1087 downto 0);
            SC_SHA3_256_en         : IN  std_logic;
            SC_SHA3_256_mux        : IN  std_logic_vector(1 downto 0);
            SC_SHA3_256_stream_out : OUT std_logic_vector(1087 downto 0)
        );
    end component SC_SHA3_256;

    component flip_flop_N_level_en_rst_n
        generic(N : positive);
        port(
            D     : in  std_logic;
            clk   : in  std_logic;
            rst_n : in  std_logic;
            en    : in  std_logic;
            Q     : out std_logic
        );
    end component flip_flop_N_level_en_rst_n;



    signal SC_stream_out1, SC_stream_out2, SC_stream_out3: std_logic_vector(1343 downto 0);
    signal SC_last_block_1, SC_last_block_2, SC_last_block_3: std_logic;

    signal en_1: std_logic;

    signal SEL_MUX_stream: std_logic_vector(1 downto 0);
    signal SEL_MUX: std_logic_vector(4 downto 0);
    signal SEL_MUX_DELAYED: std_logic_vector(4 downto 0);
    SIGNAL sel_mux_mem_add: std_logic_vector(5 downto 0);

    signal count5_rst_n, count5_en: std_logic;
    signal r_cycles: std_logic_vector(4 downto 0);
    signal rcycles_MEM: std_logic_vector(4 downto 0);
    signal r_mem_address: std_logic_vector(3 downto 0);

    signal SC_SHA3_512_stream_out: std_logic_vector(575 downto 0);
    signal SC_SHA3_512_OUT, SC_SHA3_256_OUT: std_logic_vector(1087 downto 0);
    signal SC_SHA3_256_stream_out: std_logic_vector(1087 downto 0);
    signal zeros: std_logic_vector(511 downto 0);

    signal last_block, LAST_block_mux_out, SC_last_block_SHA3_512_0110: std_logic;



    TYPE state IS (IDLE, WAITING, PROCESSING, PROCESSING_2, ELABORATE_2, DONE);
    SIGNAL y: state;


begin


    zeros <= (others=>'0');

    i_counter: counter_5bit
        port map(
            counter_5bit_rst_n => count5_rst_n,
            counter_5bit_clk   => SC_CLK,
            counter_5bit_en    => count5_en,
            counter_5bit_out   => r_cycles
        );

    reg_sel: reg_en_rst_n
        generic map(
            N => 2
        )
        port map(
            D     => SEL_MUX(1 downto 0),
            en    => '1',
            rst_n => SC_RST_N,
            clk   => SC_CLK,
            Q     => SEL_MUX_stream
        );

    i_reg_MUX_SEL: reg_en_rst_n
        generic map(
            N => 5
        )
        port map(
            D     => SEL_MUX,
            en    => '1',
            rst_n => SC_RST_N,
            clk   => SC_CLK,
            Q     => SEL_MUX_DELAYED
        );

    i_SC_SHA3_256: SC_SHA3_256
        port map(
            SC_SHA3_256_CLK        => SC_CLK,
            SC_SHA3_256_RST_N      => SC_RST_N,
            SC_SHA3_256_stream_in  => SC_stream_in,
            SC_SHA3_256_en         => en_1,
            SC_SHA3_256_mux        => SEL_MUX_stream,
            SC_SHA3_256_stream_out => SC_SHA3_256_stream_out
        );

    i_SC_SHA3_512: SC_SHA3_512
        port map(
            SC_SHA3_512_CLK        => SC_CLK,
            SC_SHA3_512_RST_N      => SC_RST_N,
            SC_SHA3_512_stream_in  => SC_stream_in(575 downto 0),
            SC_SHA3_512_en         => en_1,
            SC_SHA3_512_mux => SEL_MUX_DELAYED,
            SC_SHA3_512_stream_out => SC_SHA3_512_stream_out
        );

    SC_SHA3_512_OUT <= zeros & SC_SHA3_512_stream_out;
    SC_SHA3_256_OUT <= SC_SHA3_256_stream_out;

    i_MUX_SC_stream_out: bN_2to1mux
        generic map(
            N => 1088
        )
        port map(
            x      => SC_SHA3_256_OUT,
            y      => SC_SHA3_512_OUT,
            s      => SC_MODE(0),
            output => SC_stream_out
        );



    i_last_block: component COMPARATOR_EQ
        generic map(
            N => 5
        )
        port map(
            COMPARATOR_EQ_IN0 => r_cycles,
            COMPARATOR_EQ_IN1 => rcycles_MEM,
            COMPARATOR_EQ_OUT => last_block
        );

    i_reg_last_block_1: flipflop_en_rst_n
        port map(
            D     => last_block,
            clk   => SC_CLK,
            en => SC_SHA3_READY,
            rst_n => SC_RST_N,
            Q     => SC_last_block_1
        );

    i_reg_last_block_2: flipflop_en_rst_n
        port map(
            D     => SC_last_block_1,
            clk   => SC_CLK,
            en => SC_SHA3_READY,
            rst_n => SC_RST_N,
            Q     => SC_last_block_2
        );

    i_reg_last_block_3: flipflop_en_rst_n
        port map(
            D     => SC_last_block_2,
            clk   => SC_CLK,
            en => SC_SHA3_READY,
            rst_n => SC_RST_N,
            Q     => SC_last_block_3
        );

    i_FF_levelN_SHA3_512: flip_flop_N_level_en_rst_n
        generic map(
            N => 10
        )
        port map(
            D     => last_block,
            clk   => SC_CLK,
            rst_n => SC_RST_N,
            en    => SC_SHA3_READY,
            Q     => SC_last_block_SHA3_512_0110
        );


    r_mem_address <= SC_MODE & SC_OP;

    i_rcycle_mem: rcycle_MEM
        port map(
            rcycle_CLK => SC_CLK,
            rcycle_MEM_IN_ADDRESS => r_mem_address,
            rcycle_MEM_OUT        => rcycles_MEM
        );

    i_sel_MUX: sel_MUX_MEM
        generic map(
            data_length    => 5,
            address_length => 6
        )
        port map(
            sel_MUX_MEM_IN_CLK     => SC_CLK,
            sel_MUX_MEM_IN_ADDRESS => sel_mux_mem_add,
            sel_MUX_MEM_OUT        => SEL_MUX
        );


    sel_mux_mem_add <= SC_MODE(0) & r_cycles;

    i_MUX_last_block: component b_2to1mux
        port map(
            x      => SC_last_block_3,
            y      => SC_last_block_SHA3_512_0110,
            s      => SC_MODE(0),
            output => LAST_block_mux_out
        );


    SC_last_block <= LAST_block_mux_out;
    ----------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------

    main: process (SC_CLK, SC_RST_N)
    begin  -- process
        if SC_RST_N = '0' then -- asynchronous reset (active low)

            y <= IDLE;

            --INITIALIZATION
            count5_rst_n <= '0';
            count5_en <='0';
            SC_DONE <= '0';

            en_1 <='0';

        elsif SC_CLK'event and SC_CLK = '1' then  -- rising clock edge
            case y is

                when IDLE =>

                    if (SC_START = '1') then

                        y <= WAITING;
                        count5_rst_n <= '1';

                    else
                        y <= IDLE;
                    end if;


                when WAITING =>

                    en_1 <= '0';

                    if SC_AB_READY ='1' then
                        y <= PROCESSING;
                        count5_en <='1';
                        en_1 <= '1';


                    end if;

                    if last_block ='1' then
                        y<= PROCESSING_2;
                    end if;


                when PROCESSING =>

                    count5_en <='0';
                    en_1 <= '0';

                    if SC_one_stream_op='1' then
                        y <= DONE;
                    else
                        y <= WAITING;
                    end if;

                when PROCESSING_2 =>

                    if SC_SHA3_READY='1' then
                        y <= ELABORATE_2;
                    else
                        y <= PROCESSING_2;
                    end if;

                    count5_en <='0';
                    en_1 <= '0';

                when ELABORATE_2 =>

                    if (LAST_block_mux_out='1') then
                        y <= DONE;
                    else
                        y <= PROCESSING_2;
                    end if;

                    count5_en <='1';

                when DONE => -- @suppress "Dead state 'DONE': state does not have outgoing transitions"

                    SC_DONE <='1';
                    en_1 <= '0';
                    count5_en <='0';
                    null;


            end case;
        end if;
    end process;



end architecture RTL;
