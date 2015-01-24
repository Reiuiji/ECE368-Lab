---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   [Engineer 1]
--             [Engineer 2]
-- 
-- Create Date:    [Date]
-- Module Name:    [Module Name]
-- Project Name:   [Project Name]
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  [Insert Description]
--
-- Notes:
--  [Insert Notes]
--
-- Revision:
--  [Insert Revision]
--
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity [Name]_TopLevel_design is
    PORT (
        CLOCK       : in  STD_LOGIC;
        [IN_Port0]  : in  STD_LOGIC;
        [IN_Port1]  : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        [OUT_Port0] : out STD_LOGIC;
        [OUT_Port1] : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
    );
end [Name]_TopLevel_design;

architecture Structural of [Name]_TopLevel_design is

signal [IN_Port0]  : in  STD_LOGIC;
signal [IN_Port1]  : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal [OUT_Port0] : out STD_LOGIC;
signal [OUT_Port1] : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)

begin

    [OUT_PORT] <= [DATA_OUT];

    ----- Structural Components: -----
    -- [Name] UNIT
    [Name]_Unit : entity work.Unit_File
    port map (
        --COMPONENT        SIGNAL
        CLOCK       => CLOCK,
        [IN_Port0]  => [IN_Port0],
        [IN_Port1]  => [IN_Port1],
        [OUT_Port0] => [OUT_Port0],
        [OUT_Port1] => [OUT_Port1]
    );
    
    
end Structural;

