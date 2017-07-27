library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY EventDetector_tb IS
END EventDetector_tb;
 
ARCHITECTURE behavior OF EventDetector_tb IS 
    constant C_ADC_RESOLUTION : INTEGER := 10;
 
    COMPONENT EventDetector
    generic (
        C_ADC_RESOLUTION      : INTEGER := C_ADC_RESOLUTION
      );
    PORT(
            I_ADC1 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            I_ADC2 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            I_TRESHOLD1 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            I_TRESHOLD2 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            O_DETECTED : out STD_LOGIC;
            I_ENABLED : in STD_LOGIC
        );
    END COMPONENT;
    

    signal I_ADC1 : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := (others => '0');
    signal I_ADC2 : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := (others => '0');
    signal I_TRESHOLD1 : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := STD_LOGIC_VECTOR(to_unsigned(200, C_ADC_RESOLUTION));
    signal I_TRESHOLD2 : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := STD_LOGIC_VECTOR(to_unsigned(300, C_ADC_RESOLUTION));
    signal O_DETECTED : STD_LOGIC := '0';
    signal I_ENABLED : STD_LOGIC := '0';
 
BEGIN
    uut: EventDetector PORT MAP (
          I_ADC1 => I_ADC1,
          I_ADC2 => I_ADC2,
          I_TRESHOLD1 => I_TRESHOLD1,
          I_TRESHOLD2 => I_TRESHOLD2,
          O_DETECTED => O_DETECTED,
          I_ENABLED => I_ENABLED
        );
 
    SimulationProcess: process begin	
        I_ENABLED <= '1';	
        I_ADC1 <= STD_LOGIC_VECTOR(to_unsigned(100, C_ADC_RESOLUTION));
        I_ADC2 <= STD_LOGIC_VECTOR(to_unsigned(100, C_ADC_RESOLUTION));
        wait for 1ns;
        assert (O_DETECTED = '0') report "Should not detect an event" severity error;
        
        wait for 50ns;
        I_ADC1 <= STD_LOGIC_VECTOR(to_unsigned(400, C_ADC_RESOLUTION));
        I_ADC2 <= STD_LOGIC_VECTOR(to_unsigned(400, C_ADC_RESOLUTION));
        wait for 1ns;
        assert (O_DETECTED = '1') report "Should detect an event" severity error;
        
        wait;
    end process;

END;
