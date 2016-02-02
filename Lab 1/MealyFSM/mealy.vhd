---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
-- Module Name:    MEALY
-- Project Name:   MEALY MACHINE
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Mealy
--  Finite State Machine (FSM)
--  Mealy: The Output is a function of a present
--    state and inputs
---------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mealy IS -- Mealy machine
    PORT ( CLK: in  BIT;
           RST: in  BIT;
           X:   in  BIT;
           Z:   out BIT);
END mealy;

ARCHITECTURE Behavior OF mealy IS

    TYPE STATE_TYPE IS (S0, S1, S2);
    SIGNAL CURRENT_STATE, NEXT_STATE: STATE_TYPE;

    BEGIN
        -- Process to hold combinational logic.
        COMBIN: PROCESS(CURRENT_STATE, X)
        BEGIN
            CASE CURRENT_STATE IS
                WHEN S0 =>
                    IF X = '0' THEN
                        Z <= '0';
                        NEXT_STATE <= S0;
                    ELSE
                        Z <= '0';
                        NEXT_STATE <= S1;
                    END IF;
                WHEN S1 =>
                    IF X = '0' THEN
                        Z <= '1';
                        NEXT_STATE <= S0;
                    ELSE
                        Z <= '0';
                        NEXT_STATE <= S1;
                    END IF;
            END CASE;
        END PROCESS COMBIN;

        -- Pprocess to hold synchronous elements (flip-flops)
        SYNCH: PROCESS
        BEGIN
            IF (RST='1') THEN
                    CURRENT_STATE <= S0;
            ELSIF (CLK'EVENT AND CLK = '1') THEN
                    CURRENT_STATE <= NEXT_STATE;
            END IF;
        END PROCESS SYNCH;

END Behavior;
