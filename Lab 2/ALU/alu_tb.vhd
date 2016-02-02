---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    ALU_TB
-- Project Name:   ALU
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: ALU Test Bench
---------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.STD_LOGIC_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY ALU_tb_vhd IS
END ALU_tb_vhd;

ARCHITECTURE behavior OF ALU_tb_vhd IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ALU
    PORT( CLK      : in  STD_LOGIC;    
          RA       : in  STD_LOGIC_VECTOR(7 downto 0);
          RB       : in  STD_LOGIC_VECTOR(7 downto 0);
          OPCODE   : in  STD_LOGIC_VECTOR(3 downto 0);          
          CCR      : out STD_LOGIC_VECTOR(3 downto 0);
          ALU_OUT  : out STD_LOGIC_VECTOR(7 downto 0);
          LDST_OUT : out STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    --Inputs
    SIGNAL CLK     : STD_LOGIC := '0';
    SIGNAL RA      : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
    SIGNAL RB      : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
    SIGNAL OPCODE  : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');

    --Outputs
    SIGNAL CCR      : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL ALU_OUT  : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL LDST_OUT : STD_LOGIC_VECTOR(7 downto 0);
    
    -- Constants
    -- constant period : time := 20 ns; -- 25 MHz =(1/20E-9)/2
    constant period : time := 10 ns; -- 50 MHz =(1/10E-9)/2
    -- constant period : time := 5 ns; -- 100 MHz =(1/10E-9)/2
    
    --Condition Codes
    SIGNAL N : STD_LOGIC := '0';
    SIGNAL Z : STD_LOGIC := '0';
    SIGNAL V : STD_LOGIC := '0';
    SIGNAL C : STD_LOGIC := '0';

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ALU PORT MAP( CLK      => CLK,
                       RA       => RA,
                       RB       => RB,
                       OPCODE   => OPCODE,
                       CCR      => CCR,
                       ALU_OUT  => ALU_OUT,
                       LDST_OUT => LDST_OUT);
    
    -- Assign condition code bits
    N <= CCR(3); -- N - Negative
    Z <= CCR(2); -- Z - Zero
    V <= CCR(1); -- V - Overflow
    C <= CCR(0); -- C - Carry/Borrow
    
    -- Generate clock
    gen_Clock: process
    begin
        CLK <= '0'; wait for period;
        CLK <= '1'; wait for period;
    end process gen_Clock;

    tb : PROCESS
    BEGIN    

        -- Wait 100 ns for global reset to finish
        wait for 100 ns;

        report "Start ALU Test Bench" severity NOTE;
        
        ----- Register-Register Arithmetic Tests -----
        RA <= "00000101"; -- 5
        RB <= "00000011"; -- 3
        
        OPCODE <= "0000";  wait for period;
        assert (ALU_OUT = 8)  report "Failed ADD 1. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed ADD 1 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        OPCODE <= "0001";  wait for period;
        assert (ALU_OUT = 2)  report "Failed SUB 1. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed SUB 1 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        OPCODE <= "0010";  wait for period;
        assert (ALU_OUT = 1) report "Failed AND 1. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed AND 1 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        OPCODE <= "0011";  wait for period;
        assert (ALU_OUT = 7)  report "Failed OR 1. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed OR 1 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        RA <= "01100100"; -- 100
        RB <= "00110010"; -- 50        
        
        OPCODE <= "0000";  wait for period;
        assert (ALU_OUT = 150)  report "Failed ADD 2. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "1010")  report "Failed ADD 2 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        OPCODE <= "0001";  wait for period;
        assert (ALU_OUT = 50)  report "Failed SUB 2. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed SUB 2 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        OPCODE <= "0010";  wait for period;
        assert (ALU_OUT = "0000000000100000") report "Failed AND 2. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed AND 2 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        OPCODE <= "0011";  wait for period;
        assert (ALU_OUT = "0000000001110110")  report "Failed OR 2. ALU_OUT=" & integer'image(to_integer(unsigned(ALU_OUT))) severity ERROR;
        assert (CCR = "0000")  report "Failed OR 2 - CCR. CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        ----- END Arithmetic Tests -----
        
        ----- CCR Tests -----
        RA <= "00000000"; 
        RB <= "00000000"; 
        
        OPCODE <= "0000";  wait for period;
        assert (CCR(2) = '1')  report "Failed CCR 1 (Z). CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        RA <= "00000001"; 
        RB <= "11111111"; 
        
        OPCODE <= "0000";  wait for period;
        assert (Z = '1')  report "Failed CCR 2 (Z). CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        assert (C = '1')  report "Failed CCR 3 (C). CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        RA <= "00000000"; 
        RB <= "00000001";         
        
        OPCODE <= "0001";  wait for period;
        assert (N = '1')  report "Failed CCR 4 (N). CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        RA <= "01111111"; 
        RB <= "00000001";         
        
        OPCODE <= "0000";  wait for period;
        assert (V = '1')  report "Failed CCR 5 (V). CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        RA <= "11111111"; 
        RB <= "00000001";         
        
        OPCODE <= "0000";  wait for period;
        assert (C = '1')  report "Failed CCR 6 (C). CCR=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        ----- END CCR Tests -----
        
        -- Mem Test --
        
        OPCODE <= "1001";  wait for period;
        assert (ALU_OUT = 0) report "Failed MEMORY READ(1) ALU_OUT=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        RA <= X"16";
        OPCODE <= "1010";  wait for period;
        assert (ALU_OUT = 0) report "Failed MEMORY WRITE ALU_OUT=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        OPCODE <= "1001";  wait for period;
        assert (ALU_OUT = X"16") report "Failed MEMORY READ(2) ALU_OUT=" & integer'image(to_integer(unsigned(CCR))) severity ERROR;
        
        -- END Mem Test --
        
        report "Finish ALU Test Bench" severity NOTE;

        wait; -- will wait forever
    END PROCESS;

END;
