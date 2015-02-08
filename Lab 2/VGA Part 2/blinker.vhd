---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    BLINKER
-- Project Name:   VGA Toplevel
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Simulate a BLINKER by inverting the
--    font for 1/2 second.
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BLINKER is
    Port ( CLK        : in  STD_LOGIC;
           ADDR_B     : in  STD_LOGIC_VECTOR (11 downto 0);
           CURSOR_ADR : in  STD_LOGIC_VECTOR (11 downto 0);
           OUTPUT     : out STD_LOGIC_VECTOR (7 downto 0);
           FONT_ROM   : in  STD_LOGIC_VECTOR (7 downto 0));
end BLINKER;

architecture Behavioral of BLINKER is

    signal sel : std_logic;
    signal out1 : std_logic_vector(7 downto 0):="11111111";

begin

with sel select
	OUTPUT<=out1 when '1',
	FONT_ROM when others;

sel<='1' when ADDR_B=CURSOR_ADR else '0';

process(CLK)
variable count : integer;
begin
    if CLK'event and CLK='1' then
	    count:=count+1;
	    if count=12500000 then 
		    out1<=FONT_ROM;
	    elsif count=25000000 then
		    out1<="11111111";
		    count:=0;
	    end if;
    end if;
end process;

end Behavioral;


