---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Pixel CLK
-- Project Name:   VGA
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Pixel Clock
--  Output a 25Mhz clock for a vga controller
--  50 Mhz to 25 Mhz
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;


entity CLK_25MHZ is
  port(CLK_IN: in std_logic;
       CLK_OUT: inout std_logic);

end CLK_25MHZ;

architecture Behavioral of CLK_25MHZ is

  component CLKDLL
    generic (CLKDV_DIVIDE : real := 2.0;
             DUTY_CYCLE_CORRECTION : Boolean := TRUE;
             STARTUP_WAIT : boolean := FALSE);

    port(CLK0 : out STD_ULOGIC;
         CLK180 : out STD_ULOGIC;
         CLK270 : out STD_ULOGIC;
         CLK2X : out STD_ULOGIC;
         CLK90 : out STD_ULOGIC;
         CLKDV : out STD_ULOGIC;
         LOCKED : out STD_ULOGIC;
         CLKFB : in STD_ULOGIC;
         CLKIN : in STD_ULOGIC;
         RST : in STD_ULOGIC);
  end component;

  attribute CLKDV_DIVIDE : real;
  attribute DUTY_CYCLE_CORRECTION : boolean;
  attribute STARTUP_WAIT : boolean;

signal CLK_D: std_logic;

begin

   CLKDLL_inst : CLKDLL
   port map (
      CLK0 => open,   	  	-- 0 degree DLL CLK ouptput
      CLK180 => open, 		-- 180 degree DLL CLK output
      CLK270 => open, 		-- 270 degree DLL CLK output
      CLK2X => CLK_D,   	-- 2X DLL CLK output
      CLK90 => open,   		-- 90 degree DLL CLK output
      CLKDV => CLK_OUT,   -- Divided DLL CLK out (CLKDV_DIVIDE)
      LOCKED => open, 		-- DLL LOCK status output
      CLKFB => CLK_D,   	-- DLL clock feedback
      CLKIN => CLK_IN,   		-- Clock input (from IBUFG, BUFG or DLL)
      RST => '0'        	-- DLL asynchronous reset input
   );

end Behavioral;
