library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY Top_tb IS
END Top_tb;
 
ARCHITECTURE behavior OF Top_tb IS 
    constant C_ADC_RESOLUTION   : INTEGER := 10;
    constant C_CB_DATA_WIDTH    : INTEGER := 10;
    constant C_CB_SIZE          : INTEGER := 10;
    constant C_CB_COUNTER_BITS  : INTEGER := 10;

    COMPONENT Top
    generic (
        C_ADC_RESOLUTION    : INTEGER := C_ADC_RESOLUTION;
        C_CB_DATA_WIDTH     : INTEGER := C_CB_DATA_WIDTH;
        C_CB_SIZE           : INTEGER := C_CB_SIZE;
        C_CB_COUNTER_BITS   : INTEGER := C_CB_COUNTER_BITS
        );
    PORT(
        I_RST           : in STD_LOGIC;
        I_CLK           : in STD_LOGIC;
        I_ADC1_READY    : in STD_LOGIC;
        I_ADC2_READY    : in STD_LOGIC;
        I_ADC1_VALUE    : in STD_LOGIC_VECTOR((C_ADC_RESOLUTION - 1) downto 0);
        I_ADC2_VALUE    : in STD_LOGIC_VECTOR((C_ADC_RESOLUTION - 1) downto 0);
        I_PPS           : in STD_LOGIC
        );
    END COMPONENT;
    

   signal I_CLK             : STD_LOGIC := '0';
   signal I_RST             : STD_LOGIC := '0';
   signal I_ADC1_READY      : STD_LOGIC := '0';
   signal I_ADC2_READY      : STD_LOGIC := '0';
   signal I_ADC1_VALUE      : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := (others => '0');
   signal I_ADC2_VALUE      : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := (others => '0');
   signal I_PPS             : STD_LOGIC;

   constant C_CLK_PERIOD : time := 10 ns;
 
BEGIN
 
   uut: Top PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_ADC1_READY => I_ADC1_READY,
          I_ADC2_READY => I_ADC2_READY,
          I_ADC1_VALUE => I_ADC1_VALUE,
          I_ADC2_VALUE => I_ADC2_VALUE,
          I_PPS => I_PPS
        );

   ClockGeneratorProcess: process begin
		I_CLK <= '0';
		wait for C_CLK_PERIOD / 2;
		I_CLK <= '1';
		wait for C_CLK_PERIOD / 2;
   end process;
 
 
   SimulationProcess: process begin		
        for i in 0 to 22 loop
		  I_ADC1_VALUE <= STD_LOGIC_VECTOR(to_unsigned(i * 10, C_ADC_RESOLUTION));
		  I_ADC2_VALUE <= STD_LOGIC_VECTOR(to_unsigned(i * 9, C_ADC_RESOLUTION));
		  I_ADC1_READY <= '1';
		  I_ADC2_READY <= '1';
		  wait for C_CLK_PERIOD;
          I_ADC1_READY <= '0';
          I_ADC2_READY <= '0';
        end loop;
        
        for i in 21 downto 0 loop
          I_ADC1_VALUE <= STD_LOGIC_VECTOR(to_unsigned(i * 10, C_ADC_RESOLUTION));
          I_ADC2_VALUE <= STD_LOGIC_VECTOR(to_unsigned(i * 9, C_ADC_RESOLUTION));
          I_ADC1_READY <= '1';
          I_ADC2_READY <= '1';
          wait for C_CLK_PERIOD;
          I_ADC1_READY <= '0';
          I_ADC2_READY <= '0';
        end loop;

        wait;
   end process;

END;

