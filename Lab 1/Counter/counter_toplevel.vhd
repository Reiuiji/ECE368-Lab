---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2014
-- Module Name:    counter
-- Project Name:   CLOCK COUNTER
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Clock toplevel
--  Top level design of the clock counter
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity clock_toplevel is
    Port ( CLK : in  STD_LOGIC;                     -- 50 MHz Oscillator
           BTN : in  STD_LOGIC;                     -- Reset Button
           SW  : in  STD_LOGIC_VECTOR (1 downto 0); -- Switch 0:add/sub, 1: clk speed
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end clock_toplevel;

architecture Structural of clock_toplevel is

    signal CLOCK_DIVIDER : STD_LOGIC := '0'; -- Divided Clock Output
    signal CLK2          : STD_LOGIC := '0'; -- 2 HZ line
    signal CLK4          : STD_LOGIC := '0'; -- 4 HZ line

begin

    ----- Structural Components: -----
    clk2Hz: entity work.clk2Hz
    port map( CLK_IN  => CLK,
              RST     => BTN,
              CLK_OUT => CLK2);

    clk4Hz: entity work.clk4Hz
    port map( CLK_IN  => CLK,
              RST     => BTN,
              CLK_OUT => CLK4);

    mux1: entity work.mux_2to1
    port map( SEL  => SW(1),
              IN_1 => CLK2,
              IN_2 => CLK4,
              MOUT => CLOCK_DIVIDER);
                
    counter: entity work.counter
    port map( CLK       => CLOCK_DIVIDER,
              DIRECTION => SW(0),
              RST       => BTN,
              COUNT_OUT => LED);
    
    ----- End Structural Components -----

end Structural;






