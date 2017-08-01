library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY EventDetector_tb IS
END EventDetector_tb;
 
ARCHITECTURE behavior OF EventDetector_tb IS 
    constant C_ADC_RESOLUTION           : INTEGER := 10;
    constant C_PEAK_TIME_RESOLUTION     : INTEGER := 8;
 
    COMPONENT EventDetector
    generic (
        C_ADC_RESOLUTION        : INTEGER := C_ADC_RESOLUTION;
        C_PEAK_TIME_RESOLUTION  : INTEGER := 8
      );
    PORT(
            I_CLK           : in STD_LOGIC;
            I_RST           : in STD_LOGIC;
            I_SAMPLES       : in STD_LOGIC_VECTOR ((C_PEAK_TIME_RESOLUTION - 1) downto 0);
            I_ADC1          : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            I_ADC2          : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            I_TRESHOLD1     : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            I_TRESHOLD2     : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
            O_DETECTED      : out STD_LOGIC;
            I_ENABLED       : in STD_LOGIC
        );
    END COMPONENT;
    

    signal I_CLK        : STD_LOGIC := '0';
    signal I_RST        : STD_LOGIC := '1';
    signal I_ADC1       : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := (others => '0');
    signal I_ADC2       : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := (others => '0');
    signal O_DETECTED   : STD_LOGIC := '0';
    signal I_ENABLED    : STD_LOGIC := '0';
    
    constant C_CLK_PERIOD   : time := 10 ns;
    constant C_THRESHOLD1   : integer := 200;
    constant C_THRESHOLD2   : integer := 300;
    constant C_PEAK_TIME    : integer := 3;
 
BEGIN
    uut: EventDetector PORT MAP (
        I_CLK  => I_CLK,
        I_RST => I_RST,
        I_SAMPLES => STD_LOGIC_VECTOR(to_unsigned(C_PEAK_TIME, C_PEAK_TIME_RESOLUTION)),
        I_ADC1 => I_ADC1,
        I_ADC2 => I_ADC2,
        I_TRESHOLD1 => STD_LOGIC_VECTOR(to_unsigned(C_THRESHOLD1, C_ADC_RESOLUTION)),
        I_TRESHOLD2 => STD_LOGIC_VECTOR(to_unsigned(C_THRESHOLD2, C_ADC_RESOLUTION)),
        O_DETECTED => O_DETECTED,
        I_ENABLED => I_ENABLED
    );
 
    ClockGeneratorProcess: process begin
        I_CLK <= '0';
        wait for C_CLK_PERIOD / 2;
        I_CLK <= '1';
        wait for C_CLK_PERIOD / 2;
   end process;
 
    SimulationProcess: process begin	
        I_ENABLED <= '1';	
        I_ADC1 <= STD_LOGIC_VECTOR(to_unsigned(100, C_ADC_RESOLUTION));
        I_ADC2 <= STD_LOGIC_VECTOR(to_unsigned(100, C_ADC_RESOLUTION));
        wait for C_CLK_PERIOD * C_PEAK_TIME;
        assert (O_DETECTED = '0') report "Should not detect an event" severity error;
        
        wait for 50ns;
        I_ADC1 <= STD_LOGIC_VECTOR(to_unsigned(400, C_ADC_RESOLUTION));
        I_ADC2 <= STD_LOGIC_VECTOR(to_unsigned(400, C_ADC_RESOLUTION));
        wait for C_CLK_PERIOD * C_PEAK_TIME;
        assert (O_DETECTED = '1') report "Should detect an event" severity error;
        
        wait;
    end process;

END;
