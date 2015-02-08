---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    VGA Toplevel
-- Project Name:   VGA Toplevel
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Toplevel of the VGA Unit
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity VGA_TOPLEVEL is
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           SW       : in    STD_LOGIC_VECTOR (7 downto 0);
           PS2_CLK  : inout STD_LOGIC;
           PS2_DATA : inout STD_LOGIC;
           HSYNC    : out   STD_LOGIC;
           VSYNC    : out   STD_LOGIC;
           VGARED   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGAGRN   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGABLU   : out   STD_LOGIC_VECTOR (1 downto 0));
end VGA_TOPLEVEL;

architecture Structural of VGA_TOPLEVEL is

	signal ASCII    : STD_LOGIC_VECTOR(7 downto 0):= (OTHERS => '0');
	signal ASCII_RD : STD_LOGIC := '0';
	signal ASCII_SP : STD_LOGIC := '0';
	
	signal PCLK : STD_LOGIC;
	
	signal vcount : STD_LOGIC_VECTOR(9 downto 0):= (OTHERS => '0');
	signal hcount : STD_LOGIC_VECTOR(9 downto 0):= (OTHERS => '0');
	signal blank  : STD_LOGIC := '0';
	
	signal MUX8to1_OUT : STD_LOGIC := '0';
	signal BLINKER_OUTPUT : STD_LOGIC_VECTOR(7 downto 0):= (OTHERS => '0');
	
	
	signal ADDR_A : STD_LOGIC_VECTOR(11 downto 0):= (OTHERS => '0');
	signal ADDR_B : STD_LOGIC_VECTOR(11 downto 0):= (OTHERS => '0');
	signal ADDR_W : STD_LOGIC_VECTOR(10 downto 0):= (OTHERS => '0');
	signal DOUT_B : STD_LOGIC_VECTOR(7 downto 0):= (OTHERS => '0');
	
	signal FR_DATA: STD_LOGIC_VECTOR(7 downto 0):= (OTHERS => '0');

begin

ADDR_B <= vcount(8 downto 4)*X"50" + hcount(9 downto 3);
ADDR_W <= DOUT_B(6 downto 0) & vcount(3 downto 0);

    U1: entity work.PIXEL_CLK
    port map( CLK_IN      => CLK,
              CLK_OUT     => PCLK);

    U2: entity work.vga_controller
    port map( RST       => RST,
              PIXEL_CLK => PCLK,
              HS        => HSYNC,
              VS        => VSYNC,
              HCOUNT    => hcount,
              VCOUNT    => vcount,
              BLANK     => blank);

    U3: entity work.RGB
    port map( VALUE  => MUX8to1_OUT,
              BLANK  => blank,
              RED    => VGARED,
              GRN    => VGAGRN,
              BLU    => VGABLU);

    U4: entity work.MUX8to1
    port map( SEL    => hcount(2 downto 0),
              DATA   => BLINKER_OUTPUT,
              OUTPUT => MUX8to1_OUT);

    U5: entity work.FONT_ROM
    port map( CLK  => CLK,
              ADDR => ADDR_W,
              DATA => FR_DATA);

    U6: entity work.BLINKER
    port map( CLK        => CLK,
              ADDR_B     => ADDR_B,
              CURSOR_ADR => (OTHERS => '0'),
              OUTPUT     => BLINKER_OUTPUT,
              FONT_ROM   => FR_DATA);

    U7: entity work.VGA_BUFFER_RAM
    port map( CLKA  => CLK,
              WEA(0)   => ASCII_RD,
              ADDRA => ADDR_A,  -- (11 DOWNTO 0)
              DINA  => ASCII,   -- (7 DOWNTO 0)
              CLKB  => CLK,
              ADDRB => ADDR_B,  -- (11 DOWNTO 0)
              DOUTB => DOUT_B); -- (7 DOWNTO 0)

    U8: entity work.KEYBOARD_CONTROLLER
    port map( CLK      => CLK,
              RST      => RST,
              PS2_CLK  => PS2_CLK,
              PS2_DATA => PS2_DATA,
              ASCII    => ASCII,
              ASCII_RD => ASCII_RD,
              ASCII_SP => ASCII_SP);

end Structural;

