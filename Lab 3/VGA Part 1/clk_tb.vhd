---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    VGA_COLOR_TB
-- Project Name:   VGA_COLOR
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: VGA_COLOR Test Bench
---------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.STD_LOGIC_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY VGA_COLOR_tb_vhd IS
END VGA_COLOR_tb_vhd;

ARCHITECTURE behavior OF VGA_COLOR_tb_vhd IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT VGA_COLOR
    Port ( CLK      : in    STD_LOGIC;
           RST      : in    STD_LOGIC;
           SW       : in    STD_LOGIC_VECTOR (7 downto 0);
           HSYNC    : out   STD_LOGIC;
           VSYNC    : out   STD_LOGIC;
           VGARED   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGAGRN   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGABLU   : out   STD_LOGIC_VECTOR (1 downto 0));
    END COMPONENT;

    SIGNAL CLK     : STD_LOGIC := '0';
    SIGNAL RST     : STD_LOGIC := '0';
    SIGNAL HSYNC   : STD_LOGIC := '0';
    SIGNAL VSYNC   : STD_LOGIC := '0';
    SIGNAL VGARED  : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
    SIGNAL VGAGRN  : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
    SIGNAL VGABLU  : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
    SIGNAL SW      : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
    
    -- Constants
    -- constant period : time := 20 ns; -- 25 MHz =(1/20E-9)/2
    constant period : time := 10 ns; -- 50 MHz =(1/10E-9)/2
    -- constant period : time := 5 ns; -- 100 MHz =(1/10E-9)/2

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: VGA_COLOR PORT MAP( CLK     => CLK,
                             RST     => RST,
                             SW      => SW,
                             HSYNC   => HSYNC,
                             VSYNC   => VSYNC,
                             VGARED  => VGARED,
                             VGAGRN  => VGAGRN,
                             VGABLU  => VGABLU);

    -- Generate clock
    gen_Clock: process
    begin
        CLK <= '0'; wait for period;
        CLK <= '1'; wait for period;
    end process gen_Clock;

    tb : PROCESS
    BEGIN    

        -- Wait 100 ns for global reset to finish
        wait for 100 ns;

        report "Start VGA_COLOR Test Bench" severity NOTE;

        wait; -- will wait forever
    END PROCESS;

END;
