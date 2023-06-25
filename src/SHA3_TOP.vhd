library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity SHA3_TOP is
    port(
        SHA3_TOP_CLK: IN std_logic;
        SHA3_TOP_RST_N: IN std_logic;
        SHA3_TOP_START: IN std_logic;
        SHA3_TOP_MODE: IN std_logic_vector(1 downto 0);
        SHA3_TOP_OP: IN std_logic_vector(1 downto 0);
        SHA3_TOP_INPUT: IN std_logic_vector(63 downto 0);
        --------
        SHA3_AB_READY : OUT std_logic;
        SHA3_AB_DONE : OUT std_logic;
        ----------------------------------------------------
        SHA3_TOP_READY: OUT std_logic;
        SHA3_TOP_end: OUT std_logic;
        SHA3_TOP_DONE:    OUT std_logic;
        SHA3_TOP_OUT: OUT std_logic_vector (63 downto 0)
    );
end entity SHA3_TOP;

architecture RTL of SHA3_TOP is

    component ACQUISITION_BLOCK
    	port(
    		AB_CLK          : in  std_logic;
    		AB_RST_N        : in  std_logic;
    		AB_START        : in  std_logic;
    		AB_MODE         : in  std_logic_vector(1 downto 0);
    		AB_OP           : in  std_logic_vector(1 downto 0);
    		AB_INPUT_BUFFER : in  std_logic_vector(63 downto 0);
    		AB_ready        : out std_logic;
    		AB_OUT          : out std_logic_vector(1087 downto 0);
    		AB_done         : out std_logic
    	);
    end component ACQUISITION_BLOCK;

    component STREAM_CONTROL
    	port(
    		SC_CLK           : IN  std_logic;
    		SC_RST_N         : IN  std_logic;
    		SC_START         : IN  std_logic;
    		SC_MODE          : in  std_logic_vector(1 downto 0);
    		SC_OP            : in  std_logic_vector(1 downto 0);
    		SC_stream_in     : IN  std_logic_vector(1087 downto 0);
    		SC_one_stream_op : in  std_logic;
    		SC_AB_READY      : IN  std_logic;
    		SC_SHA3_READY    : IN  std_logic;
    		SC_stream_out    : OUT std_logic_vector(1087 downto 0);
    		SC_last_block    : OUT std_logic;
    		SC_DONE          : out std_logic
    	);
    end component STREAM_CONTROL;

    component SHA3
    	port(
    		SHA3_CLK        : in  std_logic;
    		SHA3_RST_N      : in  std_logic;
    		SHA3_START      : in  std_logic;
    		SHA3_MODE       : in  std_logic_vector(1 downto 0);
    		SHA3_OP         : in  std_logic_vector(1 downto 0);
    		SHA3_ROUND      : in  std_logic;
    		SHA3_last_block : in  std_logic;
    		SHA3_MESSAGE    : in  std_logic_vector(1343 downto 0);
    		SHA3_OUT        : out std_logic_vector (63 downto 0);
    		SHA3_ready      : out std_logic;
    		SHA3_end        : out std_logic;
    		SHA3_DONE       : out std_logic
    	);
    end component SHA3;

    component PADDING
    	port(
    		PADD_MESS_IN    : in  std_logic_vector(1087 downto 0);
    		PADD_CLK        : in  std_logic;
    		PADD_MODE       : in  std_logic_vector(1 downto 0);
    		PADD_OP         : in  std_logic_vector(1 downto 0);
    		PADD_LAST_BLOCK : in  std_logic;
    		PADD_MESS_OUT   : out std_logic_vector(1343 downto 0)
    	);
    end component PADDING;

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

    --ACQUISITION BLOCK SIGNALS
    signal AB_ready, AB_done: std_logic;
    signal AB_OUT: std_logic_vector(1087 downto 0);
    signal stream_READY: std_logic;

    --STREAM CONTROL SIGNALS
    signal SC_OUT: std_logic_vector(1087 downto 0);
    signal SC_DONE, SC_last_block: std_logic;
    
    signal one_stream_op: std_logic;
    signal sel_mux_PADDING: std_logic;

    --PADDING SIGNALS
    signal PADDING_out: std_logic_vector(1343 downto 0);
    signal PADDING_IN: std_logic_vector(1087 downto 0);

    --SHA3 CORE
    signal MESSAGE_IN: std_logic_vector(1343 downto 0);
    signal Keccak_START, Keccak_ROUND: std_logic;
    signal SHA3_ready, SHA3_DONE, SHA3_end: std_logic;

    TYPE state IS (IDLE, WAITING, PROCESSING, KECCAK_WAIT, ELABORATE, PROCESSING_2, KECCAK_WAIT_2, ELABORATE_2, POST_PROCESS, DONE);
    SIGNAL y: state;

begin

    i_ACQUISITION_BLOCK: ACQUISITION_BLOCK
        port map(
            AB_CLK          => SHA3_TOP_CLK,
            AB_RST_N        => SHA3_TOP_RST_N,
            AB_START        => SHA3_TOP_START,
            AB_MODE         => SHA3_TOP_MODE,
            AB_OP           => SHA3_TOP_OP,
            AB_INPUT_BUFFER => SHA3_TOP_INPUT,
            AB_ready        => AB_ready,
            AB_OUT          => AB_OUT,
            AB_done         => AB_done
        );

    i_FF1: flipflop_rst_n
        port map(
            D     => AB_ready,
            clk   => SHA3_TOP_CLK,
            rst_n => SHA3_TOP_RST_N,
            Q     => stream_READY
        );



    SHA3_AB_READY <= AB_ready;
    SHA3_AB_DONE <= AB_done;

    i_STREAM_CONTROL: STREAM_CONTROL
        port map(
            SC_CLK        => SHA3_TOP_CLK,
            SC_RST_N      => SHA3_TOP_RST_N,
            SC_START      => SHA3_TOP_START,
            SC_MODE => SHA3_TOP_MODE,
            SC_OP => SHA3_TOP_OP,
            SC_stream_in  => AB_OUT,
            SC_one_stream_op => one_stream_op,
            SC_AB_READY   => stream_READY,
            SC_SHA3_READY => SHA3_ready,
            SC_stream_out => SC_OUT,
            SC_last_block => SC_last_block,
            SC_DONE       => SC_DONE
        );
      
    
    i_reg_SC_out: reg_en_rst_n
        generic map(
            N => 1088
        )
        port map(
            D     => SC_OUT,
            en    => '1',
            rst_n => SHA3_TOP_RST_N,
            clk   => SHA3_TOP_CLK,
            Q     => PADDING_IN
        );
    
     one_stream_op <= SHA3_TOP_MODE(1) OR (SHA3_TOP_OP(1) AND SHA3_TOP_OP(0)) OR ((NOT SHA3_TOP_OP(1)) AND SHA3_TOP_MODE(0)) OR (SHA3_TOP_OP(1) AND (NOT SHA3_TOP_MODE(0)));
     sel_mux_PADDING <= SC_last_block OR one_stream_op;
        
    i_PADDING: PADDING
        port map(
            PADD_MESS_IN    => PADDING_IN,
            PADD_CLK        => SHA3_TOP_CLK,
            PADD_MODE       => SHA3_TOP_MODE,
            PADD_OP         => SHA3_TOP_OP,
            PADD_LAST_BLOCK => sel_mux_PADDING,
            PADD_MESS_OUT   => PADDING_out
        );
        
    i_REG_PADDING: reg_en_rst_n
        generic map(
            N => 1344
        )
        port map(
            D     => PADDING_out,
            en    => '1',
            rst_n => SHA3_TOP_RST_N,
            clk   => SHA3_TOP_CLK,
            Q     => MESSAGE_IN
        );
    
    i_SHA3_CORE: SHA3
        port map(
            SHA3_CLK     => SHA3_TOP_CLK,
            SHA3_RST_N   => SHA3_TOP_RST_N,
            SHA3_START   => Keccak_START,
            SHA3_MODE    => SHA3_TOP_MODE,
            SHA3_OP => SHA3_TOP_OP,
            SHA3_ROUND   => Keccak_ROUND,
            SHA3_last_block => SC_DONE,
            SHA3_MESSAGE => MESSAGE_IN,
            SHA3_OUT => SHA3_TOP_OUT,
            SHA3_ready   => SHA3_ready,
            SHA3_end => SHA3_end,
            SHA3_DONE    => SHA3_DONE
        );

    SHA3_TOP_end <= SHA3_end;
    SHA3_TOP_DONE <= SHA3_DONE;
    SHA3_TOP_READY <= SHA3_ready;

    ------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------

    main: process (SHA3_TOP_CLK, SHA3_TOP_RST_N)
    begin  -- process
        if SHA3_TOP_RST_N = '0' then -- asynchronous reset (active low)

            y <= IDLE;

            --INITIALIZATION
            Keccak_START <='0';
            Keccak_ROUND <='0';




        elsif SHA3_TOP_CLK'event and SHA3_TOP_CLK = '1' then  -- rising clock edge
            case y is

                when IDLE =>

                    if (SHA3_TOP_START = '1') then
                        y <= WAITING;
                    else
                        y <= IDLE;
                    end if;


                when WAITING =>

                    if stream_READY='0' then
                        y <= WAITING;
                    else
                        y <= PROCESSING;
                        Keccak_START <='1';
                    end if;

                when PROCESSING =>

                    y <=KECCAK_WAIT;

                    Keccak_ROUND <='0';
                    Keccak_START <='0';

                when KECCAK_WAIT =>

                    Keccak_START <='0';

                    if (SHA3_ready='0') then
                        y <=KECCAK_WAIT;
                    else

                        y <= ELABORATE;
                        
                        if(one_stream_op='1') then
                            Keccak_START <='0';
                            Keccak_ROUND <='0';
                        else
                            Keccak_START <='1';
                            Keccak_ROUND <='1';
                        end if;
                        
                        
                    end if;

                when ELABORATE =>

                    if (SC_last_block='0') then
                        y <=KECCAK_WAIT;
                    else
                        y <= PROCESSING_2;
                    end if;
                    Keccak_START <='0';

                when PROCESSING_2 =>

                    if (SC_DONE='1') then
                        y <= DONE;
                    else
                        y <= KECCAK_WAIT_2;
                    end if;


                when KECCAK_WAIT_2 =>

                    if (SHA3_ready='0') then
                        y <=KECCAK_WAIT_2;
                    else
                        if(SC_DONE='1') then
                            y <= DONE;
                            Keccak_START <='0';
                        else
                            y <= ELABORATE_2;
                            Keccak_START <='1';
                            Keccak_ROUND <='1';
                        end if;
                    end if;

                when ELABORATE_2 =>

                    if (SC_DONE='1') then
                        y <= POST_PROCESS;
                        Keccak_START <='0';
                    else
                        y <= KECCAK_WAIT_2;
                    end if;

                    Keccak_START <='0';
                
                when POST_PROCESS =>
                    
                    if (SHA3_DONE='1') then
                        y <= DONE;
                    else
                        y <= POST_PROCESS;
                    end if;
                    
                    
                when DONE => -- @suppress "Dead state 'DONE': state does not have outgoing transitions"


                    null;


            end case;
        end if;
    end process;



end architecture RTL;