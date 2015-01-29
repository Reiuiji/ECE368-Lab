---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    ALU_Arithmetic_Unit
-- Project Name:   ALU
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Artithmetic Unit
--  Operations - Add, Sub, Addi
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Arith_Unit is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           OP     : in  STD_LOGIC_VECTOR (2 downto 0);
           CCR    : out STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out STD_LOGIC_VECTOR  (7 downto 0));
end Arith_Unit;

architecture Combinational of Arith_Unit is

    signal a1, b1  : STD_LOGIC_VECTOR (8 downto 0) := (OTHERS => '0');
    signal arith : STD_LOGIC_VECTOR (8 downto 0) := (OTHERS => '0');

begin
    -- Give extra bit to accound for carry,overflow,negative
    a1 <= '0' & A;
    b1 <= '0' & B;

    with OP select
        arith <=
            a1 + b1 when "000", -- ADD
            a1 - b1 when "001", -- SUB
            a1 + b1 when "101", -- ADDI
            a1 + b1 when OTHERS;

    CCR(3) <= arith(7); -- Negative
    CCR(2) <= '1' when arith(7 downto 0) = x"0000" else '0'; -- Zero
    CCR(1) <= arith(8) xor arith(7); -- Overflow
    CCR(0) <= arith(8); --Carry

    RESULT <= arith(7 downto 0);
end Combinational;

