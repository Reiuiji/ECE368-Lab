---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    ALU_Logic_Unit
-- Project Name:   ALU
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Logic Unit
--  Operations - AND, OR, CMP, ANDI
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Logic_Unit is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           OP     : in  STD_LOGIC_VECTOR (2 downto 0);
           CCR    : out STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out STD_LOGIC_VECTOR  (7 downto 0));
end Logic_Unit;

architecture Combinational of Logic_Unit is

    signal cmp: STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');

begin

    with OP select
        RESULT <=
            A and B when "010", -- AND  REG A, REG B
            A or  B when "011", -- OR   REG A, REG B
            x"00"   when "100", -- CMP  REG A, REG B
            A and B when OTHERS;-- ANDI REG A, IMMED

    --Compare Operation
    cmp(3) <= '1' when a<b else '0'; -- N when s<r
    cmp(2) <= '1' when a=b else '0'; -- Z when s=r

    -- Choose CCR output
    with OP select
        ccr <=
            cmp    when "100",
            "0000" when OTHERS;

end Combinational;
