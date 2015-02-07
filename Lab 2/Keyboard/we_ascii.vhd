---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Ascii Write enable
-- Project Name:   Keyboard Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Ascii write enable
--    Outputs whether the ascii value can be writen
--     or not(special char)
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WE_ASCII is
    Port ( ASCII_IN : in  STD_LOGIC_VECTOR(7 downto 0);
           ASCII_WE : out STD_LOGIC);
end WE_ASCII;

architecture dataflow of WE_ASCII is

begin

with ASCII_IN select
		ASCII_WE <=
			'0' when x"00",	-- NUL
			'0' when x"01",	-- SOH
			'0' when x"02",	-- STX
			'0' when x"03",	-- ETX
			'0' when x"04",	-- EOT
			'0' when x"05",	-- ENQ
			'0' when x"06",	-- ACK
			'0' when x"07",	-- BEL
			'0' when x"08",	-- BS
			'0' when x"09",	-- HT
			'0' when x"0A",	-- LF
			'0' when x"0B",	-- VT
			'0' when x"0C",	-- FF
			'0' when x"0D",	-- CR
			'0' when x"0E",	-- SO
			'0' when x"0F",	-- SI
			'0' when x"10",	-- DLE
			'0' when x"11",	-- DC1
			'0' when x"12",	-- DC2
			'0' when x"13",	-- DC3
			'0' when x"14",	-- DC4
			'0' when x"15",	-- NAK
			'0' when x"16",	-- SYN
			'0' when x"17",	-- ETB
			'0' when x"18",	-- CAN
			'0' when x"19",	-- EM
			'0' when x"1A",	-- SUB
			'0' when x"1B",	-- ESC
			'0' when x"1C",	-- FS
			'0' when x"1D",	-- GS
			'0' when x"1E",	-- RS
			'0' when x"1F",	-- US
			'1' when OTHERS;  -- Valid Input

end dataflow;

