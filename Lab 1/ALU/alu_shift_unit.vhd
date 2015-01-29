---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    ALU_Shift_Unit
-- Project Name:   ALU
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Shift Unit
--  Operations - Shift Left, Shift Right
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_Shift_Unit is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           COUNT  : in  STD_LOGIC_VECTOR (2 downto 0);
           OP     : in  STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR  (7 downto 0));

end ALU_Shift_Unit;

architecture Combinational of ALU_Shift_Unit is

    signal shift_left, shift_right : std_logic_vector (7 downto 0) := (OTHERS => '0');

begin

    shift_left  <= to_stdlogicvector(to_bitvector(A) sll conv_integer(COUNT));
    shift_right <= to_stdlogicvector(to_bitvector(A) srl conv_integer(COUNT));

    RESULT <= shift_left when OP='0' else shift_right;

end Combinational;

