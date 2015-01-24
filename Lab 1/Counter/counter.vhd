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
-- Description: Counter
--  Will increase the counter(output) ever time
--  the clock does a rising action
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    Port ( CLK       : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC;
           RST       : in  STD_LOGIC;
           COUNT_OUT : out STD_LOGIC_VECTOR (7 downto 0));
               
end counter;

architecture Behavioral of counter is

    signal count : std_logic_vector(0 to 7) := "00000000";
    begin
        process (CLK, RST)
        begin
            if (RST = '1') then 
                    count <= "00000000";
            elsif (CLK'event and CLK = '1') then
                if DIRECTION = '1' then
                    count <= count + 1;
                else
                    count <= count - 1;
                end if;
            end if;
        end process;
    COUNT_OUT <= count;
end Behavioral;

