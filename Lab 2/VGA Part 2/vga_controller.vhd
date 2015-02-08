---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    VGA Controller
-- Project Name:   VGA
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Driver a VGA display
--   Display out an resolution of 800x600@60Hz
-- Notes:
--   For more information on a VGA display:
--     https://eewiki.net/pages/viewpage.action?pageId=15925278
--     http://digilentinc.com/Data/Documents/Reference%20Designs/VGA%20RefComp.zip
--   Always read the spec sheets
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_controller is
    Port ( RST       : in std_logic;
           PIXEL_CLK : inout std_logic;
           HS        : out std_logic;
           VS        : out std_logic;
           HCOUNT    : out std_logic_vector(9 downto 0);
           VCOUNT    : out std_logic_vector(9 downto 0);
           BLANK     : out std_logic);
end vga_controller;

architecture Behavioral of vga_controller is

-- maximum value - horizontal pixel counter
constant HMAX  : std_logic_vector(9 downto 0) := "1100100000"; --  800
-- maximum value - vertical pixel counter
constant VMAX  : std_logic_vector(9 downto 0) := "1000001101"; --  525
-- total visible columns
constant HLINES: std_logic_vector(9 downto 0) := "1010000000"; --  640
-- horizontal counter - front porch ends
constant HFP   : std_logic_vector(9 downto 0) := "1010001000"; --  648
-- horizontal counter - synch pulse ends
constant HSP   : std_logic_vector(9 downto 0) := "1011101000"; --  744
-- total visible lines
constant VLINES: std_logic_vector(9 downto 0) := "0111100000"; --  480
-- vertical counter - front porch ends
constant VFP   : std_logic_vector(9 downto 0) := "0111100010"; --  482
-- vertical counter - synch pulse ends
constant VSP   : std_logic_vector(9 downto 0) := "0111100100"; --  484
-- polarity of the horizontal and vertical synch pulse
constant SPP   : std_logic := '0';

signal hcounter : std_logic_vector(9 downto 0) := (others => '0');
signal vcounter : std_logic_vector(9 downto 0) := (others => '0');
signal video_enable: std_logic;

begin

    hcount <= hcounter;
    vcount <= vcounter;
    blank <= not video_enable when rising_edge(PIXEL_CLK);
    video_enable <= '1' when (hcounter < HLINES and vcounter < VLINES) else '0';

    -- horizontal counter
    h_count: process(PIXEL_CLK)
    begin
        if(rising_edge(PIXEL_CLK)) then
            if(rst = '1') then
                hcounter <= (others => '0');
            elsif(hcounter = HMAX) then
                hcounter <= (others => '0');
            else
                hcounter <= hcounter + 1;
            end if;
        end if;
    end process h_count;

    -- vertical counter
    v_count: process(PIXEL_CLK)
    begin
        if(rising_edge(PIXEL_CLK)) then
            if(rst = '1') then
                vcounter <= (others => '0');
            elsif(hcounter = HMAX) then
                if(vcounter = VMAX) then
                    vcounter <= (others => '0');
                else
                    vcounter <= vcounter + 1;
                end if;
            end if;
        end if;
    end process v_count;

    -- horizontal synch pulse
    do_hs: process(PIXEL_CLK)
    begin
        if(rising_edge(PIXEL_CLK)) then
            if(hcounter >= HFP and hcounter < HSP) then
                HS <= SPP;
            else
                HS <= not SPP;
            end if;
        end if;
    end process do_hs;

    -- generate vertical synch pulse
    do_vs: process(PIXEL_CLK)
    begin
        if(rising_edge(PIXEL_CLK)) then
            if(vcounter >= VFP and vcounter < VSP) then
                VS <= SPP;
            else
                VS <= not SPP;
            end if;
        end if;
    end process do_vs;

end Behavioral;
