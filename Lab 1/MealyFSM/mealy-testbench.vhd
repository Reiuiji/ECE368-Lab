---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
-- Module Name:    MEALY TestBench
-- Project Name:   MEALY MACHINE
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Mealy
--  Finite State Machine (FSM)
--  Mealy: The Output is a function of a present
--    state and inputs
---------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.STD_LOGIC_unsigned.all;
USE ieee.numeric_std.ALL;

entity mealy_tb is
end mealy_tb;

architecture io_test of mealy_tb is

    component mealy
    port ( CLK: in  BIT;
           RST: in  BIT;
           X:   in  BIT;
           Z:   out BIT);
    end component;

    signal CLK_TEST:    BIT := '0';
    signal RESET_TEST:  BIT := '0';
	 signal X_IN_TEST:   BIT := '0';
    signal Z_OUT_TEST:  BIT;

    -- Constants
    -- constant period : time := 20 ns; -- 25 MHz =(1/20E-9)/2
    constant period : time := 10 ns; -- 50 MHz =(1/10E-9)/2
    -- constant period : time := 5 ns; -- 100 MHz =(1/10E-9)/2

begin

     -- Instantiate the Unit Under Testing (UUT)
     uut: mealy port map(
        CLK => CLK_TEST,
        RST => RESET_TEST,
        X   => X_IN_TEST,
        Z   => Z_OUT_TEST
     );
    --Another Method of Port Map
    --uut: mealy port map(CLK_TEST,RESET_TEST,X_IN_TEST,Z_OUT_TEST);


    CLK_Process: process
    begin
        CLK_TEST <= '0'; wait for period;
        CLK_TEST <= '1'; wait for period;
    end process CLK_Process;

    tb : process
    begin

        wait for 100 ns;
        report "Starting mealy Test Bench" severity NOTE;

        ----- Unit Test -----
        --Reset
        RESET_TEST <= '1'; wait for period;
        RESET_TEST <= '0'; wait for period;

        X_IN_TEST  <= '0'; wait for 50 ns;
        X_IN_TEST  <= '1'; wait for 90 ns;
        X_IN_TEST  <= '0'; wait for 130 ns;
        X_IN_TEST  <= '0'; wait for 170 ns;
        X_IN_TEST  <= '1'; wait for 210 ns;
        X_IN_TEST  <= '1'; wait for 250 ns;
        X_IN_TEST  <= '0';
    end process;

end;
