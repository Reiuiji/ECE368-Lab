---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    VGA_COLOR_TB
-- Project Name:   VGA_COLOR
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: KEYBOARD_CONTROLLER Test Bench
---------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.STD_LOGIC_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY KEYBOARD_CONTROLLER_tb_vhd IS
END KEYBOARD_CONTROLLER_tb_vhd;

ARCHITECTURE behavior OF KEYBOARD_CONTROLLER_tb_vhd IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT KEYBOARD_CONTROLLER
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           PS2_CLK  : inout STD_LOGIC;
           PS2_DATA : inout STD_LOGIC;
           ASCII_OUT: out   STD_LOGIC_VECTOR (7 downto 0);
           ASCII_RD : out   STD_LOGIC;
           ASCII_WE : out   STD_LOGIC);
    END COMPONENT;

    SIGNAL CLK     : STD_LOGIC := '0';
    SIGNAL RST     : STD_LOGIC := '0';
    SIGNAL PS2_CLK : STD_LOGIC := '1';
    SIGNAL PS2_DATA: STD_LOGIC := '1';
    SIGNAL ASCII_OUT  : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
    SIGNAL ASCII_RD: STD_LOGIC := '0';
    SIGNAL ASCII_WE: STD_LOGIC := '0';
    
    -- Constants
    -- constant period : time := 20 ns; -- 25 MHz =(1/20E-9)/2
    constant period : time := 10 ns; -- 50 MHz =(1/10E-9)/2
    -- constant period : time := 5 ns; -- 100 MHz =(1/10E-9)/2

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: KEYBOARD_CONTROLLER PORT MAP( CLK  => CLK,
                             RST     => RST,
                             PS2_CLK => PS2_CLK,
                             PS2_DATA=> PS2_DATA,
                             ASCII_OUT => ASCII_OUT,
                             ASCII_RD=> ASCII_RD,
                             ASCII_WE=> ASCII_WE);

    -- Generate clock
    gen_Clock: process
    begin
        CLK <= '0'; wait for period;
        CLK <= '1'; wait for period;
    end process gen_Clock;

    tb : PROCESS
    BEGIN    

        -- Wait 100 ns for global reset to finish
        wait for 100 us;

        report "Start VGA_Controller Test Bench" severity NOTE;

        --Simulate Pressing A
        --Sending the Break Code X"F0"
        --Start bit '0'
        PS2_DATA <= '0';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 7 LSB
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 6
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 5
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 4
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 3
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 2
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 1
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 0 MSB
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        -- Odd Parity Bit
        PS2_DATA <= '1';
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        -- Stop Bit '1'
        PS2_DATA <= '1';
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- END Transmission
        PS2_CLK  <= '1';
        wait for 100 us;

        --Sending the Key Code X"1C"
        --Start bit '0'
        PS2_DATA <= '0';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 7 LSB
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 6
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 5
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 4
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- 3
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 2
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 1
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '0'; -- 0 MSB
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        -- Odd Parity Bit
        PS2_DATA <= '0';
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        -- Stop Bit '1'
        PS2_DATA <= '1';
        PS2_CLK  <= '1';
        wait for 30 us;
        PS2_CLK  <= '0';
        wait for 30 us;

        PS2_DATA <= '1'; -- END Transmission
        PS2_CLK  <= '1';
        wait for 100 us;

        wait; -- will wait forever
    END PROCESS;

END;
