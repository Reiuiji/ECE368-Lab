---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Keyboard Controller
-- Project Name:   Keyboard Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Keyboard Controller
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity VGA_COLOR is
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           SW       : in    STD_LOGIC_VECTOR (7 downto 0);
           HSYNC    : out   STD_LOGIC;
           VSYNC    : out   STD_LOGIC;
           VGARED   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGAGRN   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGABLU   : out   STD_LOGIC_VECTOR (1 downto 0));
end VGA_COLOR;

architecture Structural of VGA_COLOR is

    signal PCLK      : STD_LOGIC := '0';
    signal hcount    : STD_LOGIC_VECTOR (10 downto 0):= (OTHERS => '0');
    signal vcount    : STD_LOGIC_VECTOR (10 downto 0):= (OTHERS => '0');
    signal blank     : STD_LOGIC := '0';

begin

    Pixel_clk: entity work.PIXEL_CLK
    port map( CLK_IN      => CLK,
              CLK_OUT     => PCLK);

    RGB: entity work.RGB
    port map( VALUE  => SW,
              BLANK  => blank,
              RED    => VGARED,
              GRN    => VGAGRN,
              BLU    => VGABLU);

    VGA_controller: entity work.vga_controller
    port map( RST       => RST,
              PIXEL_CLK => PCLK,
              HS        => HSYNC,
              VS        => VSYNC,
              HCOUNT    => hcount,
              VCOUNT    => vcount,
              BLANK     => blank);

end Structural;

