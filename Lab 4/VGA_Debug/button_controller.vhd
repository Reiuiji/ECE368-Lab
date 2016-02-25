---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
-- Module Name:    Button Controller
-- Project Name:   Button Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Button Controller
--  Four input debouncer
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity buttoncontrol is
    Port ( CLK     : in  STD_LOGIC;
           INPUT   : in  STD_LOGIC_VECTOR (3 downto 0);
           OUTPUT  : out STD_LOGIC_VECTOR (3 downto 0));
end buttoncontrol;

architecture Structural of buttoncontrol is

	signal EN : STD_LOGIC := '1';

begin

    BTN_0: entity work.debounce
    port map( CLK    => CLK,
              EN    => EN,
              INPUT  => INPUT(0),
              OUTPUT => OUTPUT(0));

    BTN_1: entity work.debounce
    port map( CLK    => CLK,
              EN    => EN,
              INPUT  => INPUT(1),
              OUTPUT => OUTPUT(1));

    BTN_2: entity work.debounce
    port map( CLK    => CLK,
              EN    => EN,
              INPUT  => INPUT(2),
              OUTPUT => OUTPUT(2));

    BTN_3: entity work.debounce
    port map( CLK    => CLK,
              EN    => EN,
              INPUT  => INPUT(3),
              OUTPUT => OUTPUT(3));

end Structural;
