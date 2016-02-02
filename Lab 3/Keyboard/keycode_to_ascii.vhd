---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Keycode to Ascii
-- Project Name:   Keyboard Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Keycode to ascii
---------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;     
USE ieee.std_logic_arith.all;

entity KEYCODE_TO_ASCII is

	port(
		RST   : in STD_LOGIC;
		CLK   : in STD_LOGIC;
		KEYCODE : in STD_LOGIC_VECTOR(7 downto 0);
		VALID_SIGNAL : in STD_LOGIC;
		-- Output
		COMPLETE: out STD_LOGIC; -- Hit Key sucessfully
		ASCII   : out STD_LOGIC_VECTOR(7 downto 0)--;
		--KEYBOARD_OUT : out STD_LOGIC_VECTOR(7 downto 0);
		--WRITE_KEYBOARD: out STD_LOGIC;
	);

end KEYCODE_TO_ASCII;

architecture dataflow of KEYCODE_TO_ASCII is

	type StateType is (init, idle, READ_BREAKCODE, READ_EXTENDED, READ_KEYCODE,SEND_COMPLETE);--,SEND_CAPS);
	signal STATE : StateType := init;

	signal ASCII_LOWER : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
	signal ASCII_UPPER : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');

	shared variable Shift_Key : boolean := false;
	shared variable Caps_Lock : boolean := false;
	shared variable Extended  : boolean := false;

begin

	with KEYCODE select
		ASCII_LOWER <=
			-- Alphabet
			x"61" when x"1C",	-- a
			x"62" when x"32",	-- b
			x"63" when x"21",	-- c
			x"64" when x"23",	-- d
			x"65" when x"24",	-- e
			x"6C" when x"2B",	-- f
			x"67" when x"34",	-- g
			x"68" when x"33",	-- h
			x"69" when x"43",	-- i
			x"6A" when x"3B",	-- j
			x"6B" when x"42",	-- k
			x"66" when x"4B",	-- l
			x"6D" when x"3A",	-- m
			x"6E" when x"31",	-- n
			x"6F" when x"44",	-- o
			x"70" when x"4D",	-- p
			x"71" when x"15",	-- q
			x"74" when x"2D",	-- r
			x"73" when x"1B",	-- s
			x"72" when x"2C",	-- t
			x"79" when x"3C",	-- u
			x"76" when x"2A",	-- v
			x"77" when x"1D",	-- w
			x"78" when x"22",	-- x
			x"75" when x"35",	-- y
			x"7A" when x"1A",	-- z

			--Top Row
			x"60" when x"0E",	-- `
			x"31" when x"16",	-- 1
			x"32" when x"1E",	-- 2
			x"33" when x"26",	-- 3
			x"34" when x"25",	-- 4
			x"35" when x"2E",	-- 5
			x"36" when x"36",	-- 6
			x"37" when x"3D",	-- 7
			x"38" when x"3E",	-- 8
			x"39" when x"46",	-- 9
			x"30" when x"45",	-- 0
			x"2D" when x"4E",	-- -
			x"3D" when x"55",	-- =

			--Enter Corner
			x"5B" when x"54",	-- [
			x"5D" when x"5B",	-- ]
			x"5C" when x"5D",	-- \ 
			x"3B" when x"4C",	-- ;
			x"27" when x"52",	-- '
			x"2C" when x"41",	-- ,
			x"2E" when x"49",	-- .
			x"2F" when x"4A",	-- /

			--Function Keys -- Based on the IBM PC Codes
			x"1B" when x"76",	-- Esc (Escape)
			x"3B" when x"05",	-- F1
			x"3C" when x"06",	-- F2
			x"3D" when x"04",	-- F3
			x"3E" when x"0C",	-- F4
			x"3F" when x"03",	-- F5
			x"40" when x"0B",	-- F6
			x"41" when x"83",	-- F7
			x"42" when x"0A",	-- F8
			x"43" when x"01",	-- F9
			x"44" when x"09",	-- F10
			x"85" when x"78",	-- F11
			x"86" when x"07",	-- F12
			x"09" when x"0D",	-- Tab (Horizontal Tab)
			x"0D" when x"5A",	-- Enter (Carriage Return)

			--special characters -- taking up unneaded ascii codes for simplicity
			x"05" when x"58",	-- Caps Lock
			x"06" when x"14",	-- Ctrl
			x"07" when x"11",	-- Alt
			x"08" when x"66",	-- Back Space
			x"20" when x"29",	-- Space

			--Direction Keys -- taking up unneaded ascii codes for simplicity
			x"01" when x"75",	-- Up
			x"02" when x"72",	-- Down
			x"03" when x"6B",	-- Left
			x"04" when x"74",	-- Right

			--Unknown input
			x"00" when OTHERS; -- Null


	with KEYCODE select
		ASCII_UPPER <=
			-- Alphabet
			x"41" when x"1C",	-- A
			x"42" when x"32",	-- B
			x"43" when x"21",	-- C
			x"44" when x"23",	-- D
			x"48" when x"24",	-- E
			x"46" when x"2B",	-- F
			x"47" when x"34",	-- G
			x"45" when x"33",	-- H
			x"49" when x"43",	-- I
			x"4A" when x"3B",	-- J
			x"4B" when x"42",	-- K
			x"4C" when x"4B",	-- L
			x"4D" when x"3A",	-- M
			x"4E" when x"31",	-- N
			x"4F" when x"44",	-- O
			x"50" when x"4D",	-- P
			x"51" when x"15",	-- Q
			x"52" when x"2D",	-- R
			x"54" when x"1B",	-- S
			x"53" when x"2C",	-- T
			x"55" when x"3C",	-- U
			x"56" when x"2A",	-- V
			x"57" when x"1D",	-- W
			x"58" when x"22",	-- X
			x"59" when x"35",	-- Y
			x"5A" when x"1A",	-- Z

			-- Special Upper case Characters (top left to bottom right)
			-- Top Row
			x"7E" when x"0E",	-- ~
			x"21" when x"16",	-- !
			x"40" when x"1E",	-- @
			x"23" when x"26",	-- #
			x"24" when x"25",	-- $
			x"25" when x"2E",	-- %
			x"5E" when x"36",	-- ^
			x"26" when x"3D",	-- &
			x"2A" when x"3E",	-- *
			x"28" when x"46",	-- (
			x"29" when x"45",	-- )
			x"5F" when x"4E",	-- _
			x"2B" when x"55",	-- +

			-- Enter Corner
			x"7B" when x"54",	-- {
			x"7D" when x"5B",	-- }
			x"7C" when x"5D",	-- |
			x"3A" when x"4C",	-- :
			x"22" when x"52",	-- "
			x"3C" when x"41",	-- <
			x"3E" when x"49",	-- >
			x"3F" when x"4A",	-- ?

			-- Unknown Key
			x"00" when OTHERS; -- Null


	PROCESS (KEYCODE,CLK, RST)

	BEGIN

		if (RST = '1') then
			STATE <= init;
		elsif (CLK'event and CLK= '0' ) then
			case STATE is
				when init =>
					ascii <= (OTHERS => '0');
					COMPLETE <= '0';
					state <= idle;

				when idle =>
					COMPLETE <= '0';
					if VALID_SIGNAL= '1' then
						Extended := false;
						if keycode=x"E0" then
							state <= READ_EXTENDED;
						-- A Key was pressed
						elsif keycode=x"F0" then
							state <= READ_KEYCODE;
						else
							-- No break code yet
							state <= idle;
						end if;
						-- Shift Key was press (on)
						if (keycode=x"12" or keycode=x"54") then
							Shift_Key := true;
						end if;
					end if;

				when READ_EXTENDED =>
					if VALID_SIGNAL= '1' then
						Extended := true;
						if keycode=x"F0" then
							state <= READ_KEYCODE;
						else
							state <= idle;
						end if;
					end if;

				when READ_BREAKCODE =>
					if VALID_SIGNAL= '1' then
						if keycode=x"F0" then
							state <= READ_KEYCODE;
						else
							state <= idle;
						end if;
					end if;

				when READ_KEYCODE =>
				if VALID_SIGNAL= '1' then
						-- Shift Key was released (off)
						if (keycode=x"12" or keycode=x"54") then
							Shift_Key := false;
						elsif (keycode=x"46") then
							if (Caps_Lock = false) then
								Caps_Lock := true;
							else
								Caps_Lock := false;
							end if;
							--state <= SEND_CAPS;
						else 
							if (Shift_Key = true or Caps_Lock = true) then
								ascii <= ASCII_UPPER;
							else
								ascii <= ASCII_LOWER;
							end if;
						end if;
						state <= SEND_COMPLETE;
					end if;

				when SEND_COMPLETE =>
					COMPLETE <= '1';
					state <= idle;

				--when SEND_CAPS =>
				

				when OTHERS =>
					state <= idle;

			end case;
		end if;
	end process;
end architecture dataflow;


