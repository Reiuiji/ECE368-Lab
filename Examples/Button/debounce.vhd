---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Debouncer
-- Project Name:   Button Controller
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Debouncer
--  Debounce Input Signal
--  Input is fed through two flip flops
--  If both flip flops(2 cycles) have a high then
--   the counter will increment till it goes to
--   the necessary wait time.
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity debounce is
    Generic ( wait_time : INTEGER := 20);
    -- Wait_time is a fixed time to wait to validate a debounce signal
    -- Wait time is based on the Nexys 50 MHZ Clock
    -- XX : (2^xx + 2)/CLK
    -- 21 : 41.9ms | (2^21 + 2)/50E6
    -- 20 : 21.0ms | (2^20 + 2)/50E6
    -- 19 : 10.5ms | (2^19 + 2)/50E6
    -- 18 :  5.2ms | (2^18 + 2)/50E6

    Port ( CLK    : in  STD_LOGIC;
           EN    : in  STD_LOGIC;
           INPUT  : in  STD_LOGIC;
           OUTPUT : out STD_LOGIC);
end debounce;

architecture Logic of debounce is

    signal D_STATE : STD_LOGIC_VECTOR (1 downto 0);
    signal D_SET   : STD_LOGIC;
    signal Count   : STD_LOGIC_VECTOR( wait_time downto 0) := (others => '0');

begin

    D_SET <= D_STATE(0) xor D_STATE(1);
    --Check what the deboune states are
    -- *if their is a change in state then D_SET will be set to a high

    input_monitor: process (EN, CLK)
    begin
        if (CLK'event and CLK = '1' and EN = '1') then
            D_STATE(0) <= INPUT;
            D_STATE(1) <= D_STATE(0);
            if(D_SET = '1') then
                Count <= (others => '0');
            elsif(Count(wait_time) = '0') then
                Count <= Count + 1;
            else
                OUTPUT <= D_STATE(1);
            end if;
        end if;
    end process;
    
end Logic;

