---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    CLK4Hz
-- Project Name:   CLOCK COUNTER
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Clock Divider
--  Lower the Clock frequency from
--  50 Mhz to 4 hz
--  50Mhz = 50,000,000/12,500,000 = 2 Hz 
--  4Hz  ~= 1/2 second 
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk4Hz is
    Port ( CLK_IN  : in  STD_LOGIC;
           RST     : in  STD_LOGIC;
           CLK_OUT : out  STD_LOGIC);
end clk4Hz;

architecture Behavioral of clk4Hz is

    signal clkdv: STD_LOGIC:='0';
    signal counter : integer range 0 to 12500000 := 0;

begin
    frequency_divider: process (RST, CLK_IN) begin
        if (RST = '1') then
            clkdv <= '0';
            counter <= 0;
        elsif rising_edge(CLK_IN) then
            if (counter = 12500000) then
                    if(clkdv='0') then
                        clkdv <= '1';
                     else
                        clkdv <= '0';
                    end if;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    CLK_OUT <= clkdv;
end Behavioral;

