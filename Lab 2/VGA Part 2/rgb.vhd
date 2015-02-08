---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    RGB
-- Project Name:   VGA
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Enable for RGB
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity RGB is
    Port ( VALUE : in STD_LOGIC;
           BLANK : in std_logic;
           RED   : out  STD_LOGIC_VECTOR(2 downto 0);
           GRN   : out  STD_LOGIC_VECTOR(2 downto 0);
           BLU   : out  STD_LOGIC_VECTOR(1 downto 0));
end RGB;

architecture Behavioral of RGB is
signal enb : std_logic;
begin

RED<="000" when BLANK='1' else VALUE & VALUE & VALUE;
GRN<="000" when BLANK='1' else VALUE & VALUE & VALUE;
BLU<="00"  when BLANK='1' else VALUE & VALUE;
end Behavioral;


