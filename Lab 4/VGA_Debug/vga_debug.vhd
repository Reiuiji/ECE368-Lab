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
-- Description: vga debug unit test
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity VGA_Debug is
    Port ( CLK      : in    STD_LOGIC;
           BTN      : in    STD_LOGIC_VECTOR (3 downto 0);
           SW       : in    STD_LOGIC_VECTOR (7 downto 0);
           HSYNC    : out   STD_LOGIC;
           VSYNC    : out   STD_LOGIC;
           VGARED   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGAGRN   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGABLU   : out   STD_LOGIC_VECTOR (1 downto 0));
end VGA_Debug;

architecture Structural of VGA_Debug is

    signal RST : STD_LOGIC := '0';

    signal DATA_WE : STD_LOGIC := '0';
    signal DATA_ADR: STD_LOGIC_VECTOR(11 downto 0) := (OTHERS => '0');
    signal DATA    : STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
    
    signal DBTN     : STD_LOGIC_VECTOR(3 downto 0) := (OTHERS => '0');

    type DEBUG_STATE_TYPE IS (INIT, READY, ARMED, TRIGGER, RESET, DUMP, CLR);
    signal DEBUG_STATE: DEBUG_STATE_TYPE;
    
    signal DEBUG_CNT : STD_LOGIC_VECTOR(3 downto 0) := (OTHERS => '0');
    signal DEBUG_RUN_FLAG: STD_LOGIC := '0';
    signal DEBUG_CLR_FLAG: STD_LOGIC := '0';
    
    
    --ALU
    signal RA       : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    signal RB       : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    signal OPCODE   : STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
    signal CCR      : STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
    signal ALU_OUT  : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    signal LDST_OUT  : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    
    
    --Debug Buffer:
    -- DEBUG DATA: [RA][RB][OPCODE][ALU_OUT][CCR] = [8][8][4][8][4]
    signal DEBUG_DATA : STD_LOGIC_VECTOR (31 downto 0) := (OTHERS => '0');
    signal DEBUG_RAM_EN  : STD_LOGIC := '0';
    signal DEBUG_OUT_DATA : STD_LOGIC_VECTOR(3 downto 0) := (OTHERS => '0');
    
    --Debug Run Process
    type RUN_STATE_TYPE IS (INIT, READY, RUN, COMPLETE);
    signal RUN_STATE: RUN_STATE_TYPE := INIT;
    
    signal RUN_FLAG: STD_LOGIC := '0';
    signal RUN_COMPLETE: STD_LOGIC := '0';
    
    --DEBUG BUFFER SEND
    signal DD_WE  : STD_LOGIC := '0';
    signal DB_DATA_ADR : STD_LOGIC_VECTOR(11 downto 0) := (OTHERS => '0');
    signal DB_DATA     : STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
    
    
    --Data Dump Process
    type DD_STATE_TYPE IS (INIT, READY, RUN, SPACE, COMPLETE);
    signal DD_STATE: DD_STATE_TYPE := INIT;
    
    signal DD_ADR     : STD_LOGIC_VECTOR(6 downto 0) := (OTHERS => '0');
    signal DD_FLAG: STD_LOGIC := '0';
    signal DD_COMPLETE: STD_LOGIC := '0';
    signal DD_SPACE_COMPLETE  : STD_LOGIC := '0';
    signal DD_SPACE_MUX  : STD_LOGIC := '0';
    signal DD_DATA     : STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
    signal DD_ADR_8     : STD_LOGIC_VECTOR(3 downto 0) := (OTHERS => '0');
    
    
    --CLEAR DATA SIGNALS
    type VGACLR_STATE_TYPE IS (INIT, READY, RUN, COMPLETE);
    signal VGACLR_STATE: VGACLR_STATE_TYPE := INIT;
    signal VGACLR_FLAG: STD_LOGIC := '0';
    signal VGACLR_COMPLETE: STD_LOGIC := '0';
    signal VGACLR_MUX : STD_LOGIC := '0';
    signal VGACLR_WE  : STD_LOGIC := '0';
    signal VGACLR_ADR : STD_LOGIC_VECTOR(11 downto 0) := (OTHERS => '0');
    signal VGACLR_DATA: STD_LOGIC_VECTOR(7 downto 0) := x"20";
    
    signal TEST_PIN  : STD_LOGIC := '0';

begin

RUN_FLAG <= DBTN(0);
DD_FLAG <= DBTN(1);
VGACLR_FLAG <= DBTN(2);
RST <= DBTN(3);

VGACLR_DATA <= SW;

DEBUG_DATA <= RA & RB & OPCODE & ALU_OUT & CCR;
--DEBUG_DATA <= CCR & ALU_OUT & OPCODE & RB & RA;

DB_DATA_ADR(6 downto 0) <= DD_ADR;
DB_DATA_ADR(11 downto 7) <= (OTHERS => '0');

DD_ADR_8 <= DD_ADR(3 downto 0);

    U1: entity work.VGA_DRIVER
    port map( CLK       => CLK,
              RST       => RST,
              DATA_CLK  => CLK,
              DATA_WE   => DATA_WE,
              DATA_ADR  => DATA_ADR,
              DATA      => DATA,
              HSYNC     => HSYNC,
              VSYNC     => VSYNC,
              VGARED    => VGARED,
              VGAGRN    => VGAGRN,
              VGABLU    => VGABLU);


    U2: entity work.buttoncontrol
    port map( CLK   => CLK,
              INPUT => BTN,
              OUTPUT=> DBTN);

    U3: entity work.ALU
    port map( CLK     => CLK,
              RA      => RA,
              RB      => RB,
              OPCODE  => OPCODE,
              CCR     => CCR,
              ALU_OUT => ALU_OUT,
              LDST_OUT=> LDST_OUT);

    U4: entity work.DEBUG_RAM
    port map( CLKA  => CLK,
              WEA(0)=> DEBUG_RAM_EN,
              ADDRA => DEBUG_CNT,
              DINA  => DEBUG_DATA,
              CLKB  => CLK,
              ADDRB => DD_ADR,
              DOUTB => DEBUG_OUT_DATA);
              
    
    U5: entity work.Data_Decode
    port map( HEXNUM  => DEBUG_OUT_DATA,
              ASCIINUM=> DB_DATA);



    --TEST VALUES
    WITH DEBUG_CNT SELECT
        RA  <= x"00"  WHEN x"0",
               x"01"  WHEN x"1",
               x"04"  WHEN x"2",
               x"08"  WHEN x"3",
               x"42"  WHEN x"4",
               x"FF"  WHEN OTHERS;
    WITH DEBUG_CNT SELECT
        RB  <= x"00"  WHEN x"0",
               x"01"  WHEN x"1",
               x"04"  WHEN x"2",
               x"08"  WHEN x"3",
               x"42"  WHEN x"4",
               x"FF"  WHEN OTHERS;
    WITH DEBUG_CNT SELECT
        OPCODE  <= x"0"  WHEN x"0",
                   x"0"  WHEN x"1",
                   x"1"  WHEN x"2",
                   x"2"  WHEN x"3",
                   x"3"  WHEN x"4",
                   x"4"  WHEN x"5",
                   x"5"  WHEN OTHERS;
 
    --Debug Run Process
    DEBUG_RUN: PROCESS(RUN_FLAG,CLK)
    BEGIN
        IF(RST = '1') THEN
            RUN_STATE <= INIT;
        ELSIF(RISING_EDGE(CLK)) THEN
            CASE RUN_STATE IS
                WHEN INIT => 
                    RUN_STATE <= READY;
                    DEBUG_CNT <= (OTHERS => '0');
                    DEBUG_RAM_EN <= '0';

                WHEN READY =>
                    IF(RUN_FLAG = '1') THEN
                        DEBUG_RAM_EN <= '1';
                        RUN_STATE <= RUN;
                    END IF;
                    
                WHEN RUN =>
                    if (DD_ADR = x"F") then -- Test Count
                        RUN_STATE <= COMPLETE;
                        DEBUG_RAM_EN <= '0';
                    else
                        DEBUG_CNT <= DEBUG_CNT + 1;
                    end if;
                WHEN COMPLETE =>
                    IF(RUN_FLAG = '0') THEN
                        RUN_COMPLETE <= '0';
                        RUN_STATE <= INIT;
                    ELSE
                        RUN_COMPLETE <= '1';
                    END IF;
                WHEN OTHERS =>
                    RUN_STATE <= INIT;
            END CASE;
        END IF;
    END PROCESS DEBUG_RUN;
 
 
    --Dump Data from debug buffer
    DATADUMP: PROCESS(DD_FLAG,CLK)
    BEGIN
        IF(RST = '1') THEN
            DD_STATE <= INIT;
        ELSIF(RISING_EDGE(CLK)) THEN
            CASE DD_STATE IS
                WHEN INIT => 
                    DD_ADR <= (OTHERS => '0');
                    DD_WE <= '0';
                    DD_STATE <= READY;
                    --DD_SPACE_COMPLETE <= '0';

                WHEN READY =>
                    IF(DD_FLAG = '1') THEN
                        DD_WE <= '1';
                        DD_STATE <= RUN;
                    END IF;
                    
                WHEN RUN =>
                    if (DD_ADR = x"4F") then --4F = 128 => limit of DEBUG
                        DD_ADR <= DD_ADR + 1;
                        DD_WE <= '0';
                        DD_STATE <= COMPLETE;
                    else
--                        if(DD_ADR_8 = "111") THEN
--                            if(DD_SPACE_COMPLETE = '1') THEN
--                                DD_ADR <= DD_ADR + 1;
--                                DD_SPACE_COMPLETE <= '0';
--                            else
--                                DD_SPACE_COMPLETE <= '1';
--                                DD_SPACE_MUX <= '1';
--                                DD_STATE <= SPACE;
--                            end if;
--                        else
                            DD_ADR <= DD_ADR + 1;
--                        end if;
                    end if;
                    
--                WHEN SPACE =>
--                        DD_SPACE_MUX <= '0';
--                        DD_STATE <= RUN;
                WHEN COMPLETE =>
                    IF(DD_FLAG = '0') THEN
                        DD_COMPLETE <= '0';
                        DD_STATE <= INIT;
                    ELSE
                        DD_COMPLETE <= '1';
                    END IF;
                WHEN OTHERS =>
                    DD_STATE <= INIT;
            END CASE;
        END IF;
    END PROCESS DATADUMP;
    
    DD_DATA <= DB_DATA;
--    WITH DD_SPACE_MUX SELECT
--        DD_DATA  <= DB_DATA  WHEN '0',
--                    VGACLR_DATA   WHEN '1',
--                    DB_DATA  WHEN OTHERS;
    
    --Clear the entire VGA Buffer
    VGACLR: PROCESS(VGACLR_FLAG,CLK)
    BEGIN
        IF(RST = '1') THEN
            VGACLR_STATE <= INIT;
        ELSIF(RISING_EDGE(CLK)) THEN
            CASE VGACLR_STATE IS
                WHEN INIT => 
                    VGACLR_ADR <= (OTHERS => '0');
                    VGACLR_MUX <= '0';
                    VGACLR_WE <= '0';
                    VGACLR_STATE <= READY;

                WHEN READY =>
                    IF(VGACLR_FLAG = '1') THEN
                        VGACLR_MUX <= '1';
                        VGACLR_WE <= '1';
                        VGACLR_STATE <= RUN;
                    END IF;
                    
                WHEN RUN =>
                    if (VGACLR_ADR = x"FFF") then --Process complete
                        VGACLR_ADR <= VGACLR_ADR + 1;
                        VGACLR_WE <= '0';
                        VGACLR_STATE <= COMPLETE;
                    else
                        VGACLR_ADR <= VGACLR_ADR + 1;
                    end if;
                WHEN COMPLETE =>
                    IF(VGACLR_FLAG = '0') THEN
                        VGACLR_COMPLETE <= '0';
                        VGACLR_STATE <= INIT;
                    ELSE
                        VGACLR_COMPLETE <= '1';
                    END IF;
                WHEN OTHERS =>
                    VGACLR_STATE <= INIT;
            END CASE;
        END IF;
    END PROCESS VGACLR;
    
    --VGA_CLR MUX's
    WITH VGACLR_MUX SELECT
        DATA_WE  <=      DD_WE  WHEN '0',
                    VGACLR_WE   WHEN '1',
                         DD_WE  WHEN OTHERS;

    WITH VGACLR_MUX SELECT
        DATA_ADR <= DB_DATA_ADR WHEN '0',
                    VGACLR_ADR  WHEN '1',
                    DB_DATA_ADR WHEN OTHERS;

    WITH VGACLR_MUX SELECT
        DATA     <= DD_DATA     WHEN '0',
                    VGACLR_DATA WHEN '1',
                    DD_DATA     WHEN OTHERS;
    

end Structural;

