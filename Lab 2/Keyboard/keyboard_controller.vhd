---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Keyboard Controller
-- Project Name:   Keyboard Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Keyboard Controller
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity KEYBOARD_CONTROLLER is
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           PS2_CLK  : inout STD_LOGIC;
           PS2_DATA : inout STD_LOGIC;
           ASCII_OUT: out   STD_LOGIC_VECTOR (7 downto 0); -- Include Basic Ascii (no extension codes)
           ASCII_RD : out   STD_LOGIC; -- Indicate Ascii value is available to read
           ASCII_WE : out   STD_LOGIC); -- Can the Character write(none special character)
end KEYBOARD_CONTROLLER;

architecture Structural of KEYBOARD_CONTROLLER is

    signal TX_DATA : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    signal RX_DATA : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    signal WR      : STD_LOGIC := '0';
    signal RD      : STD_LOGIC := '0';
    signal BS      : STD_LOGIC := '0';
    signal ER      : STD_LOGIC := '0';


    signal ASCII : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
--    signal A_RD    : STD_LOGIC := '0';
--    signal A_SP    : STD_LOGIC := '0';

begin

ASCII_OUT <= ASCII;

    U1: entity work.PS2_DRIVER
    port map( CLK      => CLK,
              RST      => RST,
              PS2_CLK  => PS2_CLK,
              PS2_DATA => PS2_DATA,
              TX_DATA  => TX_DATA,
              WR       => WR,
              RX_DATA  => RX_DATA,
              RD       => RD,
              BS       => BS,
              ER       => ER);

    U2: entity work.KEYCODE_TO_ASCII
    port map( CLK          => CLK,
              RST          => RST,
              KEYCODE      => RX_DATA,
              VALID_SIGNAL => RD,
              COMPLETE     => ASCII_RD,
              ASCII        => ASCII);

    U3: entity work.WE_ASCII
    port map( ASCII_IN  => ASCII,
              ASCII_WE => ASCII_WE);


-- ASCII Generator: Buggy, use at ones risk
--    PS2_ASCII_GEN: entity work.PS2_ASCII_GEN
--    port map( CLK      => CLK,
--              RST      => RST,
--              PS2_RX   => RX_DATA,
--              PS2_RD   => RD,
--              PS2_BS   => BS,
--              PS2_ER   => ER,
--              PS2_TX   => TX_DATA,
--              PS2_WR   => WR,
--              ASCII    => ASCII,
--              ASCII_RD => ASCII_RD,
--              ASCII_SP => ASCII_SP);


end Structural;

