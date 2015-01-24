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
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity [Name]_tb is
end [Name]_tb;

architecture Behavioral of [Name] is

    component [ComponentName] is

    generic(
        [VariableName]:integer:=8
    );

    port (
        CLK         : in  STD_LOGIC;
        [IN_Port0]  : in  STD_LOGIC;
        [IN_Port1]  : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        [OUT_Port0] : out STD_LOGIC;
        [OUT_Port1] : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
    );

    end component;

    signal CLK   : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';

begin

     -- Instantiate the Unit Under Testing (UUT)
     uut: [ComponentName] port map(
        CLK         => CLK         : in  STD_LOGIC;
        [IN_Port0]  => [IN_Port0]  : in  STD_LOGIC;
        [IN_Port1]  => [IN_Port1]  : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        [OUT_Port0] => [OUT_Port0] : out STD_LOGIC;
        [OUT_Port1] => [OUT_Port1] : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
     );


    m50MHZ_CLK: process
    begin
        CLK <= '0'; wait for period;
        CLK <= '1'; wait for period;
    end process m50MHZ_CLK;

    tb : process
    begin
        -- Wait 100 ns for global reset to finish
        wait for 100 ns;
        report "Starting [name] Test Bench" severity NOTE;

        ----- Unit Test -----
        --Reset
        RESET <= '1'; wait for period;
        RESET <= '0'; wait for period;
        assert ([OUT_Port0] = 00)  report "Failed READ. [OUT_Port0]=" & integer'image(to_integer(unsigned([OUT_Port0]))) severity ERROR;

        -- Test each input via loop
        for i in 0 to 256 loop 
                  [IN_Port0]  <= x"F0";
                  [OUT_Port0] <= '0'; wait for period;
                  [OUT_Port0] <= '1'; wait for period;
                  [IN_Port0]  <= std_logic_vector(to_signed(i,IN_Port0'length)); wait for 2*period;
                  [OUT_Port0] <= '0'; wait for period;
                  [OUT_Port0] <= '1'; wait for period;
        end loop;

    end process;

end Behavioral;
