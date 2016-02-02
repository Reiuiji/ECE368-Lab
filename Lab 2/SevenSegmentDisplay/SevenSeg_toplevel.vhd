---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer:   Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    SevenSeg_toplevel
-- Project Name:   SevenSegmentDisplay
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description: 7-segment toplevel example
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity SSeg_toplevel is

    port (
        CLK : in  STD_LOGIC; -- 50 MHz input
        SW  : in  STD_LOGIC_VECTOR (7 downto 0);
        BTN : in  STD_LOGIC;
        SEG : out STD_LOGIC_VECTOR (6 downto 0);
        DP  : out STD_LOGIC;
        AN  : out STD_LOGIC_VECTOR (3 downto 0)
    );

end SSeg_toplevel;

architecture Structural of SSeg_toplevel is

    signal s2  : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal s3  : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal enl : STD_LOGIC := '1';
    signal dpc : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    signal cen : STD_LOGIC := '0';

begin

    ----- Structural Components: -----
    SSeg: entity work.SSegDriver
    port map( CLK     => CLK,
              RST     => BTN,
              EN      => enl,
              SEG_0   => SW(3 downto 0),
              SEG_1   => SW(7 downto 4),
              SEG_2   => s2,
              SEG_3   => s3,
              DP_CTRL => dpc,
              COL_EN  => cen,
              SEG_OUT => SEG,
              DP_OUT  => DP,
              AN_OUT  => AN);

    
    ----- End Structural Components -----

end Structural;






