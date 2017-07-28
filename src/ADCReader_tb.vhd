library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY ADCReader_tb IS
END ADCReader_tb;
 
ARCHITECTURE behavior OF ADCReader_tb IS 
    constant C_RESOLUTION : INTEGER := 10;

    COMPONENT ADCReader
    generic (
          C_RESOLUTION      : INTEGER := C_RESOLUTION
        );
    PORT(
        I_CLK           : in STD_LOGIC;
        I_RST           : in STD_LOGIC;
        I_VALUE_READY   : in STD_LOGIC;
        O_VALUE_READY   : out STD_LOGIC;
        I_VALUE         : in STD_LOGIC_VECTOR ((C_RESOLUTION - 1) downto 0);
        O_VALUE         : out STD_LOGIC_VECTOR ((C_RESOLUTION - 1) downto 0)
        );
    END COMPONENT;
    

   signal I_CLK             : STD_LOGIC := '0';
   signal I_RST             : STD_LOGIC := '0';
   signal I_VALUE_READY     : STD_LOGIC := '0';
   signal I_VALUE           : STD_LOGIC_VECTOR ((C_RESOLUTION - 1) downto 0) := (others => '0');
   signal O_VALUE_READY     : STD_LOGIC;
   signal O_VALUE           : STD_LOGIC_VECTOR ((C_RESOLUTION - 1) downto 0) := (others => '0');

   constant C_CLK_PERIOD : time := 10 ns;
 
BEGIN
 
   uut: ADCReader PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_VALUE_READY => I_VALUE_READY,
          O_VALUE => O_VALUE,
          O_VALUE_READY => O_VALUE_READY,
          I_VALUE => I_VALUE
        );

   ClockGeneratorProcess: process begin
		I_CLK <= '0';
		wait for C_CLK_PERIOD / 2;
		I_CLK <= '1';
		wait for C_CLK_PERIOD / 2;
   end process;
 
 
   SimulationProcess: process begin		
		I_VALUE <= STD_LOGIC_VECTOR(to_unsigned(100, C_RESOLUTION));
		I_VALUE_READY <= '0';

		wait for 50ns;

		I_VALUE <= STD_LOGIC_VECTOR(to_unsigned(200, C_RESOLUTION));
		I_VALUE_READY <= '1';
		
		wait for 50ns;
		assert (to_integer(unsigned(O_VALUE)) = 200) report "Output value should be 200, same as input" severity error;

        wait;
   end process;

END;
