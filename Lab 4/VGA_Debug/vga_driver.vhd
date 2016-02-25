---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
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

entity VGA_Driver is
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           --Data INPUT
           DATA_CLK : in    STD_LOGIC;
           DATA_WE  : in    STD_LOGIC;
           DATA_ADR : in    STD_LOGIC_VECTOR (11 downto 0);
           DATA     : in    STD_LOGIC_VECTOR (7 downto 0);
           --VGA OUTPUT
           HSYNC    : out   STD_LOGIC;
           VSYNC    : out   STD_LOGIC;
           VGARED   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGAGRN   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGABLU   : out   STD_LOGIC_VECTOR (1 downto 0));
			  
end VGA_Driver;

architecture Structural of VGA_Driver is
	
	signal PCLK : STD_LOGIC;
	
	signal vcount : STD_LOGIC_VECTOR(9 downto 0):= (OTHERS => '0');
	signal hcount : STD_LOGIC_VECTOR(9 downto 0):= (OTHERS => '0');
	signal blank  : STD_LOGIC := '0';
	
	signal MUX8to1_OUT : STD_LOGIC := '0';
	
	signal BUF_ADR : STD_LOGIC_VECTOR(11 downto 0):= (OTHERS => '0');
	signal BUF_OUT : STD_LOGIC_VECTOR(7 downto 0):= (OTHERS => '0');
    
	signal FR_ADR : STD_LOGIC_VECTOR(10 downto 0):= (OTHERS => '0');
	signal FR_DATA: STD_LOGIC_VECTOR(7 downto 0):= (OTHERS => '0');
    
	signal VGA_ADR : STD_LOGIC_VECTOR(12 downto 0):= (OTHERS => '0');

begin

VGA_ADR <= vcount(8 downto 4)*X"50" + hcount(9 downto 3);
BUF_ADR <= VGA_ADR(11 downto 0);
FR_ADR <= BUF_OUT(6 downto 0) & vcount(3 downto 0);

    U1: entity work.CLK_25MHZ
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
              DATA   => FR_DATA,
              OUTPUT => MUX8to1_OUT);

    U5: entity work.FONT_ROM
    port map( CLK  => CLK,
              ADDR => FR_ADR,
              DATA => FR_DATA);

    U6: entity work.VGA_BUFFER_RAM
    port map( CLKA  => DATA_CLK,
              WEA(0)=> DATA_WE,
              ADDRA => DATA_ADR,
              DINA  => DATA,
              CLKB  => CLK,
              ADDRB => BUF_ADR,
              DOUTB => BUF_OUT);

end Structural;

