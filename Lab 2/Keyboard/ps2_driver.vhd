---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    PS/2 Driver
-- Project Name:   Keyboard Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Driver for the PS/2 line
--   17 State Finite State Machine
--
-- Notes:
--   Bi-directional setup based on (c)Digilent Nexys 2 PS2Interface Example
--    digilentinc.com/Products/Detail.cfm?Prod=NEXYS2
--   More information about PS/2 protocol:
--    http://www.computer-engineering.org/ps2protocol/
--
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PS2_DRIVER is
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           PS2_CLK  : inout STD_LOGIC;
           PS2_DATA : inout STD_LOGIC;
           TX_DATA  : in    STD_LOGIC_VECTOR (7 downto 0); --Transmit line
           WR       : in    STD_LOGIC; --Write Flag
           RX_DATA  : out   STD_LOGIC_VECTOR (7 downto 0); --Receive line
           RD       : out   STD_LOGIC; --Read Flag
           BS       : out   STD_LOGIC; --Busy Flag
           ER       : out   STD_LOGIC);--Error Flag
end PS2_DRIVER;

architecture Behavioral of PS2_DRIVER is

    ---------------------------------------------------
    -- Constants
    ---------------------------------------------------
    constant DELAY_100US  : STD_LOGIC_VECTOR(12 downto 0) := "1001110001000"; -- 5_000 in binary
    constant DELAY_20US   : STD_LOGIC_VECTOR(9 downto 0)  := "1111101000";    -- 2_000 in binary
    constant DELAY_31CLK  : STD_LOGIC_VECTOR(4 downto 0)  := "11111";         -- 31 clock cycles
    constant PS2_DEBOUNCE : STD_LOGIC_VECTOR(3 downto 0)  := "1111";          -- Delay from debouncing
    constant NUMBITS      : STD_LOGIC_VECTOR(3 downto 0)  := "1011";          -- Bits per frame
    constant PARITY_BIT   : POSITIVE                      := 9;               -- Parity loc in frame

    type ROM is array(0 to 255) of STD_LOGIC;
    constant PARITY_ROM : ROM := (
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1',
        '1','0','0','1','0','1','1','0',
        '1','0','0','1','0','1','1','0',
        '0','1','1','0','1','0','0','1');

    ---------------------------------------------------
    -- Signals
    ---------------------------------------------------
    -- Delay Counters
    signal delay_100us_count : std_logic_vector(12 downto 0) := (others => '0');
    signal delay_20us_count  : std_logic_vector(9 downto 0)  := (others => '0');
    signal delay_31CLK_count : std_logic_vector(4 downto 0)  := (others => '0');
    -- Counter Finish
    signal delay_100us_done  : std_logic;
    signal delay_20us_done   : std_logic;
    signal delay_31clk_done  : std_logic;
    -- Enable Counters
    signal delay_100us_counter_enable : std_logic := '0';
    signal delay_20us_counter_enable  : std_logic := '0';
    signal delay_31CLK_counter_enable : std_logic := '0';

    -- Sync Inputs
    signal ps2_clk_sync  : std_logic := '1';
    signal ps2_data_sync : std_logic := '1';
    -- Control PS2 Output (1 Set To High Impedance)
    signal ps2_clk_h  : std_logic := '1';
    signal ps2_data_h : std_logic := '1';
    -- PS2 Debounce Signals
    signal ps2_clk_clean  : std_logic := '1';
    signal ps2_data_clean : std_logic := '1';
    signal clk_count      : std_logic_vector(3 downto 0);
    signal data_count     : std_logic_vector(3 downto 0);
    -- Last Value on PS2 Lines
    signal clk_inter  : std_logic := '1';
    signal data_inter : std_logic := '1';

    -- Finite State Machine Setup
    type fsm_state is
    (
       idle,rx_clk_h,rx_down_edge,rx_clk_l,rx_error_parity,rx_data_ready,
       tx_force_clk_l,tx_bring_data_down,tx_release_clk,
       tx_first_wait_down_edge,tx_clk_l,tx_wait_up_edge,tx_clk_h,
       tx_wait_up_edge_before_ack,tx_wait_ack,tx_received_ack,
       tx_error_no_ack
    );
    signal state: fsm_state := idle; -- set FSM init state

    -- Register Frame Handler Signals
    signal frame           : std_logic_vector(10 downto 0) := (others => '0');
    signal bit_count       : std_logic_vector(3 downto 0)  := (others => '0');
    signal reset_bit_count : std_logic                     := '0';
    signal shift_frame     : std_logic                     := '0';

    -- Parity Signals
    signal rx_parity : std_logic := '0';
    signal tx_parity : std_logic := '0';
    -- Load Data
    signal load_tx_data : std_logic := '0';
    signal load_rx_data : std_logic := '0';

begin

    ---------------------------------------------------
    -- PS2 CLK And DATA Debounce
    ---------------------------------------------------
    debounce_ps2_clk_signal: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(ps2_clk /= clk_inter) then -- Reset counter if current and last CLK not equal
                clk_inter <= ps2_clk;
                clk_count <= (others => '0');
            elsif(clk_count = PS2_DEBOUNCE) then -- Signal is clean - debounced
                ps2_clk_clean <= clk_inter;
            else
                clk_count <= clk_count + 1; -- Nothing changed, increment counter
            end if;
        end if;
    end process debounce_ps2_clk_signal;

    debounce_ps2_data_signal: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(ps2_data /= data_inter) then -- Reset counter if current and last data not equal
                data_inter <= ps2_data;
                data_count <= (others => '0');
            elsif(data_count = PS2_DEBOUNCE) then -- Signal is clean - debounced
                ps2_data_clean <= data_inter;
            else
                data_count <= data_count + 1; -- Nothing changed, increment counter
            end if;
        end if;
    end process debounce_ps2_data_signal;

    ---------------------------------------------------
    -- FLAGS
    ---------------------------------------------------
    -- Sync The CLK and DATA lines
    ps2_clk_sync  <= ps2_clk_clean when rising_edge(CLK);
    ps2_data_sync <= ps2_data_clean when rising_edge(CLK);

    -- Parity Line
    rx_parity <= PARITY_ROM(conv_integer(frame(8 downto 1))) when rising_edge(CLK);
    tx_parity <= PARITY_ROM(conv_integer(tx_data)) when rising_edge(CLK);

    -- Set Lines High Impediance when 1
    PS2_CLK  <= 'Z' when ps2_clk_h = '1';
    PS2_DATA <= 'Z' when ps2_data_h = '1';

    -- Indicate line is busy when not idle
    BS <= '0' when state = idle else '1';
    -- Reset counters when Idle
    reset_bit_count <= '1' when state = idle else '0';

    shift_frame <= '1' when state = rx_down_edge or state = tx_clk_l else '0';

    ---------------------------------------------------
    -- DELAY COUNTERS
    ---------------------------------------------------

    -- 100US Delay Counter
    delay_100us_counter_enable <= '1' when state = tx_force_CLK_l else '0';

    delay_100us_counter: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(delay_100us_counter_enable = '1') then
                if(delay_100us_count = (DELAY_100US)) then
                    delay_100us_count <= delay_100us_count;
                    delay_100us_done <= '1';
                else
                    delay_100us_count <= delay_100us_count + 1;
                    delay_100us_done <= '0';
                end if;
            else
                delay_100us_count <= (others => '0');
                delay_100us_done <= '0';
            end if;
        end if;
    end process delay_100us_counter;

    -- 20US Delay Counter
    delay_20us_counter_enable <= '1' when state = tx_bring_data_down else '0'; 

    delay_20us_counter: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(delay_20us_counter_enable = '1') then
                if(delay_20us_count = (DELAY_20US)) then
                    delay_20us_count <= delay_20us_count;
                    delay_20us_done <= '1';
                else
                    delay_20us_count <= delay_20us_count + 1;
                    delay_20us_done <= '0';
                end if;
            else
                delay_20us_count <= (others => '0');
                delay_20us_done <= '0';
            end if;
        end if;
    end process delay_20us_counter;

    -- 31CLK Delay Counter
    delay_31CLK_counter_enable <= '1' when state = tx_first_wait_down_edge else '0';

    delay_31CLK_counter: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(delay_31CLK_counter_enable = '1') then
                if(delay_31CLK_count = (DELAY_31CLK)) then
                    delay_31CLK_count <= delay_31CLK_count;
                    delay_31clk_done <= '1';
                else
                    delay_31CLK_count <= delay_31CLK_count + 1;
                    delay_31clk_done <= '0';
                end if;
            else
                delay_31CLK_count <= (others => '0');
                delay_31clk_done <= '0';
            end if;
        end if;
    end process delay_31CLK_counter;

    ---------------------------------------------------
    -- BIT COUNTER AND FRAME SHIFTING LOGIC
    ---------------------------------------------------
    bit_counter: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(reset_bit_count = '1') then
                bit_count <= (others => '0');
            elsif(shift_frame = '1') then
                bit_count <= bit_count + 1;
            end if;
        end if;
    end process bit_counter;

    -- shifts frame with one bit to right when shift_frame is acitve
    -- and loads data into frame from tx_data then load_tx_data is high
    load_tx_data_into_frame: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(load_tx_data = '1') then
                frame(0) <= '0';              -- start bit
                frame(8 downto 1) <= tx_data; -- byte to send
                frame(9) <= tx_parity;        -- parity bit
                frame(10) <= '1';             -- stop bit
            elsif(shift_frame = '1') then
                frame(9 downto 0) <= frame(10 downto 1); -- shift right 1 bit
                frame(10) <= ps2_data_sync; -- shift in from the ps2_data line
            end if;
        end if;
    end process load_tx_data_into_frame;

    -- Loads data from frame into rx_data output when data is ready
    do_load_rx_data: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(load_rx_data = '1') then
                rx_data <= frame(8 downto 1);
            end if;
        end if;
    end process do_load_rx_data;

    ---------------------------------------------------
    -- FINITE STATE MACHINE
    ---------------------------------------------------
    ps2_fsm: process( CLK,rst,state,ps2_clk_sync,ps2_data_sync,WR,tx_data,
                      bit_count,rx_parity,frame,delay_100us_done,
                      delay_20us_done,delay_31clk_done)
    begin
        if(rst = '1') then -- Reset state, goto idle mode
            state <= idle;
        elsif(rising_edge(CLK)) then -- Process through States every rising edge of the clock
            -- Reset Values since no longer applied
            ps2_clk_h    <= '1';
            ps2_data_h   <= '1';
            load_tx_data <= '0';
            load_rx_data <= '0';
            RD           <= '0';
            ER           <= '0';

            --State Case - process through each state
            case state is

                -- IDLE State : Waiting for activity
                when idle =>
                    if(ps2_clk_sync = '0') then
                        state <= rx_down_edge;  -- goto rx_down_edge state
                    elsif(WR = '1') then
                        state <= tx_force_clk_l; -- goto tx_force_clk_l state
                    else
                        state <= idle;
                    end if;

                when rx_clk_h =>
                    if(bit_count = NUMBITS) then
                        if(not (rx_parity = frame(PARITY_BIT))) then
                            state <= rx_error_parity;
                        else
                            load_rx_data <= '1';
                            state <= rx_data_ready;
                        end if;
                    elsif(ps2_clk_sync = '0') then
                        state <= rx_down_edge;
                    else
                        state <= rx_clk_h;
                    end if;

                when rx_down_edge =>
                    state <= rx_clk_l;

                when rx_clk_l =>
                    if(ps2_clk_sync = '1') then
                        state <= rx_clk_h;
                    else
                        state <= rx_clk_l;
                    end if;

                when rx_error_parity =>
                    ER    <= '1';
                    state <= idle;

                when rx_data_ready =>
                    RD    <= '1';
                    state <= idle;

                when tx_force_clk_l =>
                    load_tx_data <= '1';
                    ps2_clk_h    <= '0';
                    if(delay_100us_done = '1') then
                        state <= tx_bring_data_down;
                    else
                        state <= tx_force_clk_l;
                    end if;

                when tx_bring_data_down =>
                    ps2_clk_h  <= '0';
                    ps2_data_h <= '0';
                    if(delay_20us_done = '1') then
                        state <= tx_release_clk;
                    else
                        state <= tx_bring_data_down;
                    end if;

                when tx_release_clk =>
                    ps2_clk_h  <= '1';
                    ps2_data_h <= '0';
                    state <= tx_first_wait_down_edge;

                when tx_first_wait_down_edge =>
                    ps2_data_h <= '0';
                    if(delay_31clk_done = '1') then
                        if(ps2_clk_sync = '0') then
                            state <= tx_clk_l;
                        else
                            state <= tx_first_wait_down_edge;
                        end if;
                    else
                        state <= tx_first_wait_down_edge;
                    end if;

                when tx_clk_l =>
                    ps2_data_h <= frame(0);
                    state <= tx_wait_up_edge;

                when tx_wait_up_edge =>
                    ps2_data_h <= frame(0);
                    if(bit_count = NUMBITS-1) then
                        ps2_data_h <= '1';
                        state <= tx_wait_up_edge_before_ack;
                    elsif(ps2_clk_sync = '1') then
                        state <= tx_clk_h;
                    else
                        state <= tx_wait_up_edge;
                    end if;

                when tx_clk_h =>
                    ps2_data_h <= frame(0);
                    if(ps2_clk_sync = '0') then
                        state <= tx_clk_l;
                    else
                        state <= tx_clk_h;
                    end if;

                when tx_wait_up_edge_before_ack =>
                    ps2_data_h <= '1';
                    if(ps2_clk_sync = '1') then
                        state <= tx_wait_ack;
                    else
                        state <= tx_wait_up_edge_before_ack;
                    end if;

                when tx_wait_ack =>
                    if(ps2_clk_sync = '0') then
                        if(ps2_data_sync = '0') then
                            state <= tx_received_ack; -- acknowledge received
                         else
                            state <= tx_error_no_ack; -- acknowledge not received
                        end if;
                    else
                        state <= tx_wait_ack;
                    end if;

                when tx_received_ack =>
                    if(ps2_clk_sync = '1' and ps2_data_sync = '1') then
                        state  <= idle;
                    else
                        state <= tx_received_ack;
                    end if;

                when tx_error_no_ack =>
                    if(ps2_clk_sync = '1' and ps2_data_sync = '1') then
                        ER <= '1';
                        state  <= idle;
                    else
                        state <= tx_error_no_ack;
                    end if;

                when others => -- Invalid transition, signal error, going back to idle
                    ER    <= '1';
                    state <= idle;
       
             end case;
        end if;
    end process ps2_fsm;

end Behavioral;
