---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Button Controller
-- Project Name:   ALU
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Switch Controller
--  Maintain input from the four buttons on Nexys
--  Built in debouncer for buttons
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity buttoncontrol is
    Port ( CLK     : in  STD_LOGIC;
           SW      : in  STD_LOGIC;
           BTN  : in  STD_LOGIC_VECTOR (3 downto 0);
           LED : out STD_LOGIC_VECTOR (3 downto 0));
end buttoncontrol;

architecture Structural of buttoncontrol is

begin

    ----- Structural Components: -----
    BTN_0: entity work.debounce
    port map( CLK    => CLK,
              EN    => SW,
              INPUT  => BTN(0),
              OUTPUT => LED(0));

    BTN_1: entity work.debounce
    port map( CLK    => CLK,
              EN    => SW,
              INPUT  => BTN(1),
              OUTPUT => LED(1));

    BTN_2: entity work.debounce
    port map( CLK    => CLK,
              EN    => SW,
              INPUT  => BTN(2),
              OUTPUT => LED(2));

    BTN_3: entity work.debounce
    port map( CLK    => CLK,
              EN    => SW,
              INPUT  => BTN(3),
              OUTPUT => LED(3));

    
    ----- End Structural Components -----

end Structural;
