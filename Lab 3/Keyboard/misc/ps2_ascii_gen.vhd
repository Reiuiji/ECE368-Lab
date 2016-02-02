---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    PS/2 Ascii Generator
-- Project Name:   Keyboard Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Generate ASCII from PS/2 input
--   Maintain Keyboard(reset,set num,caps lock)
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PS2_ASCII_GEN is
    Port ( CLK      : in  STD_LOGIC;
           RST      : in  STD_LOGIC;
           PS2_RX   : in  STD_LOGIC_VECTOR (7 downto 0);
           PS2_RD   : in  STD_LOGIC;
           PS2_BS   : in  STD_LOGIC;
           PS2_ER   : in  STD_LOGIC;
           PS2_TX   : out STD_LOGIC_VECTOR (7 downto 0);
           PS2_WR   : out STD_LOGIC;
           ASCII    : out STD_LOGIC_VECTOR (7 downto 0);
           ASCII_RD : out STD_LOGIC;
           ASCII_SP : out STD_LOGIC); -- Special Key Flag
end PS2_ASCII_GEN;

architecture Behavioral of PS2_ASCII_GEN is

    type statetype is (idle, shift, read_b, read_e, read_eb, caps_toggle, busy_wait,reset);
    signal state : statetype := idle;
    signal wstate : statetype := idle;

    signal ascii_lower : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    signal ascii_upper : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');

    shared variable shift_key : boolean := false;
    shared variable caps : boolean := false;

begin

with PS2_RX select
    ascii_lower <=
        -- Alphabet
        x"61" when x"1C",-- a
        x"62" when x"32",-- b
        x"63" when x"21",-- c
        x"64" when x"23",-- d
        x"65" when x"24",-- e
        x"66" when x"2B",-- f
        x"67" when x"34",-- g
        x"68" when x"33",-- h
        x"69" when x"43",-- i
        x"6A" when x"3B",-- j
        x"6B" when x"42",-- k
        x"6C" when x"4B",-- l
        x"6D" when x"3A",-- m
        x"6E" when x"31",-- n
        x"6F" when x"44",-- o
        x"70" when x"4D",-- p
        x"71" when x"15",-- q
        x"72" when x"2D",-- r
        x"73" when x"1B",-- s
        x"74" when x"2C",-- t
        x"75" when x"3C",-- u
        x"76" when x"2A",-- v
        x"77" when x"1D",-- w
        x"78" when x"22",-- x
        x"79" when x"35",-- y
        x"7A" when x"1A",-- z

        --Top Row
        x"60" when x"0E",-- `
        x"31" when x"16",-- 1
        x"32" when x"1E",-- 2
        x"33" when x"26",-- 3
        x"34" when x"25",-- 4
        x"35" when x"2E",-- 5
        x"36" when x"36",-- 6
        x"37" when x"3D",-- 7
        x"38" when x"3E",-- 8
        x"39" when x"46",-- 9
        x"30" when x"45",-- 0
        x"2D" when x"4E",-- -
        x"3D" when x"55",-- =

        --Enter Corner
        x"5B" when x"54",-- [
        x"5D" when x"5B",-- ]
        x"5C" when x"5D",-- \ 
        x"3B" when x"4C",-- ;
        x"27" when x"52",-- '
        x"2C" when x"41",-- ,
        x"2E" when x"49",-- .
        x"2F" when x"4A",-- /

        --Function Keys -- Based on the IBM PC Codes
        x"1B" when x"76",-- Esc (Escape)
        x"3B" when x"05",-- F1
        x"3C" when x"06",-- F2
        x"3D" when x"04",-- F3
        x"3E" when x"0C",-- F4
        x"3F" when x"03",-- F5
        x"40" when x"0B",-- F6
        x"41" when x"83",-- F7
        x"42" when x"0A",-- F8
        x"43" when x"01",-- F9
        x"44" when x"09",-- F10
        x"85" when x"78",-- F11
        x"86" when x"07",-- F12
        x"09" when x"0D",-- Tab (Horizontal Tab)
        x"0D" when x"5A",-- Enter (Carriage Return)

        --need no value *(special characters)
        x"00" when x"58",-- Caps Lock
        x"00" when x"14",-- Ctrl
        x"00" when x"11",-- Alt
        x"00" when x"66",-- Back Space

        --Direction Keys
        x"48" when x"75",-- Up
        x"50" when x"72",-- Down
        x"4B" when x"6B",-- Left
        x"4D" when x"74",-- Right

        --Unknown input
        x"00" when OTHERS; -- Null

with PS2_RX select
    ascii_upper <=
        -- Alphabet
        x"41" when x"1C",-- A
        x"42" when x"32",-- B
        x"43" when x"21",-- C
        x"44" when x"23",-- D
        x"45" when x"24",-- E
        x"46" when x"2B",-- F
        x"47" when x"34",-- G
        x"48" when x"33",-- H
        x"49" when x"43",-- I
        x"4A" when x"3B",-- J
        x"4B" when x"42",-- K
        x"4C" when x"4B",-- L
        x"4D" when x"3A",-- M
        x"4E" when x"31",-- N
        x"4F" when x"44",-- O
        x"50" when x"4D",-- P
        x"51" when x"15",-- Q
        x"52" when x"2D",-- R
        x"53" when x"1B",-- S
        x"54" when x"2C",-- T
        x"55" when x"3C",-- U
        x"56" when x"2A",-- V
        x"57" when x"1D",-- W
        x"58" when x"22",-- X
        x"59" when x"35",-- Y
        x"5A" when x"1A",-- Z

        -- Special Upper case Characters (top left to bottom right)
        -- Top Row
        x"7E" when x"0E",-- ~
        x"21" when x"16",-- !
        x"40" when x"1E",-- @
        x"23" when x"26",-- #
        x"24" when x"25",-- $
        x"25" when x"2E",-- %
        x"5E" when x"36",-- ^
        x"26" when x"3D",-- &
        x"2A" when x"3E",-- *
        x"28" when x"46",-- (
        x"29" when x"45",-- )
        x"5F" when x"4E",-- _
        x"2B" when x"55",-- +

        -- Enter Corner
        x"7B" when x"54",-- {
        x"7D" when x"5B",-- }
        x"7C" when x"5D",-- |
        x"3A" when x"4C",-- :
        x"22" when x"52",-- "
        x"3C" when x"41",-- <
        x"3E" when x"49",-- >
        x"3F" when x"4A",-- ?

        -- Unknown Key
        x"00" when OTHERS; -- Null

process (CLK,RST,PS2_RX,PS2_RD,PS2_ER)
begin
    if (RST = '1' and PS2_ER = '1') then
        state <= reset;
    elsif (PS2_RD'event and PS2_RD = '1') then--(CLK'event and CLK = '1') then
        case state is
            when idle =>
                --if (PS2_RD'event and PS2_RD = '1') then
                    ASCII_SP <= '0';
                    ASCII_RD <= '0';
                    if PS2_RX = x"F0" then
                        state <= read_b;
                    elsif PS2_RX = x"E0" then
                        state <= read_e;
                    elsif(PS2_RX = x"12" or PS2_RX = x"54") then
                        state <= shift;
                    end if;
                --end if;

            when read_b =>
                --if (PS2_RD'event and PS2_RD = '1') then
                    if caps = true then
                        ASCII <= ascii_upper;
                    else
                        ASCII <= ascii_lower;
                    end if;
                    ASCII_RD <= '1';
                --end if;

            when read_e =>
                --if (PS2_RD'event and PS2_RD = '1') then
                    if PS2_RX = x"F0" then
                        state <= read_eb;
                        ASCII_SP <= '1'; -- Enable Special Mode
                    else
                        state <= idle;
                    end if;
                --end if;

            when read_eb =>
                --if (PS2_RD'event and PS2_RD = '1') then
                    ASCII <= ascii_lower;
                    ASCII_RD <= '1';
                --end if;

            when shift =>
                --ASCII <= ascii_upper;
                --ASCII_RD <= '1';
                state <= idle;

            when caps_toggle =>
                PS2_TX <= x"ED";
                PS2_WR <= '1';

            when reset =>
                PS2_TX <= x"FF"; --send keyboard reset cmd
                PS2_WR <= '1';
                state <= idle;

            when busy_wait =>
                if PS2_BS = '0' then
                    state <= wstate;
                end if;

            when others =>
                state <= idle;

        end case;
    end if;
end process;


end Behavioral;
