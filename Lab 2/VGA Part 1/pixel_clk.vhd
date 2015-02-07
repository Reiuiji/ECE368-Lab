---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Pixel CLK
-- Project Name:   VGA
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Pixel Clock
--  Output a 40Mhz clock for a vga controller
--  50 Mhz to 40 Mhz
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PIXEL_CLK is
  port(CLK_IN: in std_logic;
       CLK_OUT: inout std_logic);

end PIXEL_CLK;

architecture Structural of PIXEL_CLK is

    signal clk100mhz      : STD_LOGIC := '0';

begin

    CLK_100MHZ: entity work.CLK_100MHZ
    port map( CLK_IN      => CLK_IN,
              CLK_OUT     => clk100mhz);

    CLK_40MHZ: entity work.CLK_40MHZ
    port map( CLK_IN      => clk100mhz,
              CLK_OUT     => CLK_OUT);

end Structural;
