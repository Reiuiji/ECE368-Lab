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
-- Description: Delay the Write Enable Line
--    Delay the Write Line to allow the ascii bus
--    to propagate through before able to read.
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WE_DELAY is
    Port ( WE_IN_1  : in  STD_LOGIC;
           WE_IN_2  : in  STD_LOGIC;
           WE_OUT_1 : out STD_LOGIC;
           WE_OUT_2 : out STD_LOGIC);
end WE_DELAY;

architecture delay of WE_DELAY is

begin

WE_OUT_1 <= transport WE_IN_1 after 10 ns;
WE_OUT_2 <= transport WE_IN_2 after 10 ns;

end delay;

