library work;
use work.keccak_globals.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity SHA3 is
    port(
        SHA3_CLK : in std_logic;
        SHA3_RST_N : in std_logic;
        SHA3_START: in std_logic;
        SHA3_MODE: in std_logic_vector(1 downto 0); --00 SHA3-256, 01 SHA3-512, 10 SHAKE128 and 11 SHAKE256
        SHA3_OP: in std_logic_vector(1 downto 0);
        SHA3_ROUND: in std_logic;
        SHA3_last_block: in std_logic;
        SHA3_MESSAGE    : in std_logic_vector(1343 downto 0);
        SHA3_OUT: out std_logic_vector (63 downto 0);
        SHA3_ready: out std_logic;  --one HASH function is ready
        SHA3_end: out std_logic;
        SHA3_DONE: out std_logic  --all the inputs have been processed
    );
end entity SHA3;

architecture RTL of SHA3 is


    ----------------------------------------------------------------------------
    -- Component declarations
    ----------------------------------------------------------------------------

    component Keccak_2to1mux
        port(
            x, y   : in  k_state;
            s      : in  std_logic;
            output : out k_state
        );
    end component Keccak_2to1mux;

    component VSX_MODULE
        port(
            VSX_IN_STATE   : in  k_state;
            VSX_IN_MESSAGE : in  std_logic_vector(1343 downto 0);
            VSX_SEL        : in  std_logic_vector(1 downto 0);
            VSX_OUT_STATE  : out k_state
        );
    end component VSX_MODULE;

    component Keccak_REG
        port(
            Keccak_REG_CLK   : in  std_logic;
            Keccak_REG_RST_N : in  std_logic;
            Keccak_REG_IN    : in  k_state;
            Keccak_REG_EN    : in  std_logic;
            Keccak_REG_OUT   : out k_state
        );
    end component Keccak_REG;

    component counter_5bit
        port(
            counter_5bit_rst_n, counter_5bit_clk, counter_5bit_en : in  std_logic;
            counter_5bit_out                                      : out std_logic_vector(4 downto 0)
        );
    end component counter_5bit;

    component COMPARATOR_EQ
        generic(N : positive := 5);
        port(
            COMPARATOR_EQ_IN0 : in  std_logic_vector(N - 1 downto 0);
            COMPARATOR_EQ_IN1 : in  std_logic_vector(N - 1 downto 0);
            COMPARATOR_EQ_OUT : out std_logic
        );
    end component COMPARATOR_EQ;

    component Keccak_core
    	port(
    		Keccak_CLK, Keccak_RST_N : in  std_logic;
    		Keccak_IN_STATE          : in  k_state;
    		Keccak_nr_round          : in  unsigned(4 downto 0);
    		Keccak_OUT_STATE         : out k_state
    	);
    end component Keccak_core;

    component TRUNC
        port(
            Keccak_State_S : in  k_state;
            TRUNC_out      : out std_logic_vector(1023 downto 0)
        );
    end component TRUNC;

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

    component out_control
        port(
            out_control_MODE     : in  std_logic_vector(1 downto 0);
            out_control_OP       : in  std_logic_vector(1 downto 0);
            out_control_end : out std_logic_vector(4 downto 0)
        );
    end component out_control;

    component output_div
        port(
            output_div_IN  : in  std_logic_vector(1023 downto 0);
            output_div_sel : in  std_logic_vector(3 downto 0);
            output_div_OUT : out std_logic_vector(63 downto 0)
        );
    end component output_div;

    ----------------------------------------------------------------------------
    -- Internal signal declarations
    ----------------------------------------------------------------------------
    signal Zero_State_S, Feedback_State_S, Init_State_S, Feedback_State_delayed, VSX_State_S: k_state;
    signal KECCAK_out_mux02: k_state;

    signal mux02_control: std_logic;
    signal counter_nr_rounds : unsigned(4 downto 0);
    signal permutation_computed: std_logic;
    signal Keccak_ready: std_logic; -- @suppress "signal Keccak_ready is never read"
    signal ready, OUTPUT_ready, en_reg_out: std_logic; -- @suppress "signal OUTPUT_ready is never read"

    signal stream_out_end: std_logic;

    signal TRUNCATED_out: std_logic_vector(1023 downto 0);
    signal SHA3_OUT_complete: std_logic_vector(1023 downto 0);

    ----counter-----------------------
    signal count5_rst_n, count5_en: std_logic;
    signal count5_out: std_logic_vector(4 downto 0);
    signal is_22: std_logic;

    signal output_div_sel: std_logic_vector(3 downto 0);
    signal output_end: std_logic_vector(4 downto 0);

    TYPE state IS (IDLE, PRE_PROC_S, PREPARE_S, KECCAK_S, KECCAK_READY_S, POST_PROC_S, PROCESSING, DONE);
    SIGNAL y: state;



begin


    -- Initialization of the state to zero
    SHA3_init_001: for i in 0 to 4 generate
        SHA3_init_002: for j in 0 to 4 generate
            Zero_State_S(i)(j)<= (others=>'0');
        end generate;
    end generate;

    mux01: Keccak_2to1mux
        port map(
            x      => Zero_State_S,
            y      => Feedback_State_delayed,
            s      => SHA3_ROUND,
            output => Init_State_S
        );


    VSX_mod: VSX_MODULE
        port map(
            VSX_IN_STATE   => Init_State_S,
            VSX_IN_MESSAGE => SHA3_MESSAGE,
            VSX_SEL => SHA3_MODE,
            VSX_OUT_STATE  => VSX_State_S
        );
    
        
        
    counter: counter_5bit
        port map(
            counter_5bit_rst_n => count5_rst_n,
            counter_5bit_clk   => SHA3_CLK,
            counter_5bit_en    => count5_en,
            counter_5bit_out   => count5_out
        );

    comparator: COMPARATOR_EQ
        generic map(
            N => 5
        )
        port map(
            COMPARATOR_EQ_IN0 => count5_out,
            COMPARATOR_EQ_IN1 => "10110",
            COMPARATOR_EQ_OUT => is_22
        );
        
    
    mux02: Keccak_2to1mux
        port map(
            x      => VSX_State_S,
            y      => Feedback_State_S,
            s      => mux02_control,
            output => KECCAK_out_mux02
        );   
    

    Keccak: Keccak_core
        port map(
            Keccak_CLK       => SHA3_CLK,
            Keccak_RST_N => SHA3_RST_N,
            Keccak_IN_STATE  => KECCAK_out_mux02,
            Keccak_nr_round => unsigned(count5_out),
            Keccak_OUT_STATE => Feedback_State_S
        );


    REG_feedback: Keccak_REG
        port map(
            Keccak_REG_CLK   => SHA3_CLK,
            Keccak_REG_RST_N => SHA3_RST_N,
            Keccak_REG_IN    => Feedback_State_S,
            Keccak_REG_EN    => ready,
            Keccak_REG_OUT   => Feedback_State_delayed
        );

    Trunc_Unit: TRUNC
        port map(
            Keccak_State_S => Feedback_State_S,
            TRUNC_out      => TRUNCATED_out
        );

    en_reg_out <= SHA3_last_block AND permutation_computed;

    Reg_TRUNC_OUT: reg_en_rst_n
        generic map(
            N => 1024
        )
        port map(
            D     => TRUNCATED_out,
            en    => en_reg_out,
            rst_n => SHA3_RST_N,
            clk   => SHA3_CLK,
            Q     => SHA3_OUT_complete
        );

    end_output_buffer: out_control
        port map(
            out_control_MODE => SHA3_MODE,
            out_control_OP   => SHA3_OP,
            out_control_end  => output_end
        );

    comparator_OUT: COMPARATOR_EQ
        generic map(
            N => 5
        )
        port map(
            COMPARATOR_EQ_IN0 => count5_out,
            COMPARATOR_EQ_IN1 => output_end,
            COMPARATOR_EQ_OUT => stream_out_end
        );

    output_buffering: output_div
        port map(
            output_div_IN  => SHA3_OUT_complete,
            output_div_sel => count5_out(3 downto 0),
            output_div_OUT => SHA3_OUT
        );

    SHA3_ready <= ready;


    -----------------------------------------------------------------------------------------------------
    -------------FSM-------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------

    main: process (SHA3_CLK, SHA3_RST_N)
    begin  -- process
        if SHA3_RST_N = '0' then -- asynchronous reset (active low)

            y <= IDLE;


            --INITIALIZATION
            count5_rst_n <='0';
            ready <= '0';
            OUTPUT_ready <= '0';
            mux02_control <='0';
            permutation_computed<='0';
            SHA3_DONE <= '0';
            SHA3_end <='0';

        elsif SHA3_CLK'event and SHA3_CLK = '1' then  -- rising clock edge
            case y is
                when IDLE =>

                    if (SHA3_START = '1') then
                        y <= PRE_PROC_S;
                    else
                        y <= IDLE;
                    end if;



                when PRE_PROC_S =>  --Padding, XORing and VSX_Module

                    --mux01_control <= SHA3_ROUND;
                    y <= PREPARE_S;

                    ready <= '0';
                    count5_rst_n <='0';
                    mux02_control <='0';


                when PREPARE_S =>

                    y <= KECCAK_S;
                    mux02_control <='1';
                    count5_en <= '1';
                    count5_rst_n <='1';

                when KECCAK_S =>  --

                    if (is_22 ='1') then

                        y <= KECCAK_READY_S;
                        permutation_computed<='1';
                        ready <= '1';
                        count5_en <= '0';

                    else
                        y <= KECCAK_S;
                        count5_en <= '1';

                    end if;


                when KECCAK_READY_S =>

                    mux02_control <='0';
                    count5_rst_n<='0';
                    permutation_computed<='0';
                    ready <= '0';

                    y<= POST_PROC_S;


                when POST_PROC_S =>

                    ready <= '0';

                    if (SHA3_START = '1') then
                        y <= PRE_PROC_S;
                    else
                        y <= PROCESSING;
                        OUTPUT_ready <= '1';
                        count5_rst_n<='1';
                        count5_en<='1';
                        SHA3_end<='1';

                    end if;

                when PROCESSING =>

                    if stream_out_end='1' then
                        y <= DONE;
                        count5_rst_n<='0';
                        count5_en<='0';
                        SHA3_DONE <= '1';
                        SHA3_end <= '0';
                    else
                        y <= PROCESSING;
                    end if;

                when DONE => -- @suppress "Dead state 'DONE': state does not have outgoing transitions"

                    SHA3_DONE <= '0';
                    count5_rst_n<='0';
                    count5_en<='0';

                    null;

            end case;
        end if;
    end process;






end architecture RTL;