---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Cursor
-- Project Name:   VGA
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Maintain the cursor on the display
--
-- Notes: Based on Prof. Fortier cursor
--    Designed to handle ascii instead of scan codes
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity CURSOR is
    Port ( ASCII_CODE  : in  STD_LOGIC_VECTOR (7 downto 0); 
           ASCII_RD    : in  STD_LOGIC; -- new ascii code
           ASCII_WE    : in  STD_LOGIC; -- ascii code can be written
           CURSOR_ADDR : out STD_LOGIC_VECTOR (11 downto 0));
end CURSOR;

architecture Behavioral of CURSOR is

    signal cursor_adr:  integer :=0;

begin

process(ASCII_RD)
--variable count_1 : integer := 0; -- maintain vertical movement
--variable count_2 : integer := 0; -- maintain horizontal movement
begin
-- Check if a new ascii value
if ASCII_RD'event and ASCII_RD='1' then
    if ASCII_WE = '1' then
        --count_1:=count_1+1;
        --if count_1=2 then
            if (cursor_adr<2400) then -- 80*30 = 2400
                cursor_adr<=cursor_adr+1;
            end if;
            --count_1:=0;
        --end if;
    else -- Special Keys
        --count_2:=count_2+1;
        --if count_2=2 then
            if ASCII_CODE = x"01" then -- Up Arrow
                cursor_adr <= cursor_adr-80;
                if cursor_adr < 0 then
                    cursor_adr <= 0;
                end if;

            elsif ASCII_CODE = x"02" then -- Down Arrow
                cursor_adr <= cursor_adr+80;
                if cursor_adr > 2400 then
                    cursor_adr <= 2400;
                end if;

            elsif ASCII_CODE = x"03" then -- Left Arrow
                cursor_adr <= cursor_adr-1;
                if cursor_adr < 0 then
                    cursor_adr <= 0;
                end if;

            elsif ASCII_CODE = x"04" then -- Right Arrow
                cursor_adr <= cursor_adr+1;
                if cursor_adr > 2400 then
                    cursor_adr <= 2400;
                end if;

            elsif ASCII_CODE = x"08" then -- Back Space
                cursor_adr <= cursor_adr-1;
                if cursor_adr < 0 then
                    cursor_adr <= 0;
                end if;

            elsif ASCII_CODE = x"0D" then -- Enter
                if (cursor_adr< 79)then
                    cursor_adr <= 80;
                elsif (cursor_adr < 159)then
                    cursor_adr <= 160;
                elsif (cursor_adr < 239)then
                    cursor_adr <= 240;
                elsif (cursor_adr < 319)then
                    cursor_adr <= 320;
                elsif (cursor_adr < 399)then
                    cursor_adr <= 400;
                elsif (cursor_adr < 479)then
                    cursor_adr <= 480;
                elsif (cursor_adr < 559)then
                    cursor_adr <= 560;
                elsif (cursor_adr < 639)then
                    cursor_adr <= 640;
                elsif (cursor_adr < 719)then
                    cursor_adr <= 720;
                elsif (cursor_adr < 799)then
                    cursor_adr <= 800;
                elsif (cursor_adr < 879)then
                    cursor_adr <= 880;
                elsif (cursor_adr < 959)then
                    cursor_adr <= 960;
                elsif (cursor_adr < 1039)then
                    cursor_adr <= 1040;
                elsif (cursor_adr < 1119)then
                    cursor_adr <= 1120;
                elsif (cursor_adr < 1199)then
                    cursor_adr <= 1200;
                elsif (cursor_adr < 1279)then
                    cursor_adr <= 1280;
                elsif (cursor_adr < 1259)then
                    cursor_adr <= 1360;
                elsif (cursor_adr < 1339)then
                    cursor_adr <= 1440;
                elsif (cursor_adr < 1519)then
                    cursor_adr <= 1520;
                elsif (cursor_adr < 1599)then
                    cursor_adr <= 1600;
                elsif (cursor_adr < 1679)then
                    cursor_adr <= 1680;
                elsif (cursor_adr < 1759)then
                    cursor_adr <= 1760;
                elsif (cursor_adr < 1839)then
                    cursor_adr <= 1840;
                elsif (cursor_adr < 1919)then
                    cursor_adr <= 1920;
                elsif (cursor_adr < 1999)then
                    cursor_adr <= 2000;
                elsif (cursor_adr < 2079)then
                    cursor_adr <= 2080;
                elsif (cursor_adr < 2159)then
                    cursor_adr <= 2160;
                elsif (cursor_adr < 2239)then
                    cursor_adr <= 2240;
                elsif (cursor_adr < 2319)then
                    cursor_adr <= 2320;
                elsif (cursor_adr < 2399)then
                    cursor_adr <= 2400;
                end if;

            end if;
            --count_2:=0;
       --end if;
    end if;
end if;
end process;

CURSOR_ADDR<=conv_std_logic_vector(cursor_adr, 12);

end Behavioral;

