---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2014
-- Module Name:    MUX_2to1
-- Project Name:   CLOCK COUNTER
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description:    2 Select MUX
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1 is
    Port ( SEL  : in  STD_LOGIC;
           IN_1 : in  STD_LOGIC;
           IN_2 : in  STD_LOGIC;
           MOUT : out STD_LOGIC);
end mux_2to1;

architecture Behavioral of mux_2to1 is

begin

    MOUT <= IN_1 when SEL='0' ELSE IN_2;

end Behavioral;

