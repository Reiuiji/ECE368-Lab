---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
-- Module Name:    VGA Data Decoder
-- Project Name:   VGA Data Decoder
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Convert a 4 bit number to a ascii value
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Data_Decode is
    Port ( HEXNUM   : in    STD_LOGIC_VECTOR (3 downto 0);
           ASCIINUM : out   STD_LOGIC_VECTOR (7 downto 0));
end Data_Decode;

architecture Structural of Data_Decode is

begin

--convert current hex to the ascii equivalent
with hexnum select
    asciinum <=
        x"30" when x"0", -- 0
        x"31" when x"1", -- 1
        x"32" when x"2", -- 2
        x"33" when x"3", -- 3
        x"34" when x"4", -- 4
        x"35" when x"5", -- 5
        x"36" when x"6", -- 6
        x"37" when x"7", -- 7
        x"38" when x"8", -- 8
        x"39" when x"9", -- 9
        x"41" when x"A", -- A
        x"42" when x"B", -- B
        x"43" when x"C", -- C
        x"44" when x"D", -- D
        x"45" when x"E", -- E
        x"46" when x"F", -- F
		  X"00" when others; -- invalid
end Structural;


