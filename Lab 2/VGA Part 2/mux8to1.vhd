---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Mux 8 to 1
-- Project Name:   VGA Toplevel
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Select one bit from a byte
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX8to1 is
    Port ( SEL : in  STD_LOGIC_VECTOR (2 downto 0);
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out  STD_LOGIC);
end MUX8to1;

architecture Behavioral of MUX8to1 is

    signal SEL1 : STD_LOGIC_VECTOR (2 downto 0);

begin

SEL1<=SEL-2;

with SEL1 SELect
    OUTPUT<= DATA(7) when "000" ,
             DATA(6) when "001" ,
             DATA(5) when "010" ,
             DATA(4) when "011" ,
             DATA(3) when "100" ,
             DATA(2) when "101" ,
             DATA(1) when "110" ,
             DATA(0) when "111" ,
                 '0' when others;
end Behavioral;

