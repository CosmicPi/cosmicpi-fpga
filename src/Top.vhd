library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Top is
     generic (
        C_ADC_RESOLUTION    : INTEGER := 10;
        C_CB_DATA_WIDTH     : INTEGER := 10;
        C_CB_SIZE           : INTEGER := 20;
        C_CB_COUNTER_BITS   : INTEGER := 8
     );

     Port ( 
        I_RST           : in STD_LOGIC;
        I_CLK           : in STD_LOGIC;
        I_ADC1_READY    : in STD_LOGIC;
        I_ADC2_READY    : in STD_LOGIC;
        I_ADC1_VALUE    : in STD_LOGIC_VECTOR((10 - 1) downto 0);    -- TODO: Replace with constant (C_ADC_RESOLUTION)
        I_ADC2_VALUE    : in STD_LOGIC_VECTOR((10 - 1) downto 0);    -- TODO: Replace with constant (C_ADC_RESOLUTION)
        I_PPS           : in STD_LOGIC
    );
end Top;

architecture Behavioral of Top is

-- DECLARATION: ADC Reader
COMPONENT ADCReader
    generic (
        C_RESOLUTION      : INTEGER := C_ADC_RESOLUTION
    );
    PORT (
        I_CLK           : in STD_LOGIC;
        I_RST           : in STD_LOGIC;
        I_VALUE_READY   : in STD_LOGIC;
        O_VALUE_READY   : out STD_LOGIC;
        I_VALUE         : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        O_VALUE         : out STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0)
    );
END COMPONENT;

-- DECLARATION: Circular Buffer
COMPONENT CircularBuffer
    generic ( 
        C_DATA_WIDTH    : INTEGER := C_CB_DATA_WIDTH;
        C_SIZE          : INTEGER := C_CB_SIZE;
    	C_COUNTER_BITS	: INTEGER := C_CB_COUNTER_BITS
    	);
    PORT(
          I_CLK     : in STD_LOGIC;
          I_ENR     : in std_logic;
          I_ENW     : in std_logic;
          O_SIZE    : out std_logic_vector((C_CB_COUNTER_BITS - 1) downto 0);
          O_DATA    : out std_logic_vector((C_CB_DATA_WIDTH - 1) downto 0);
          I_DATA    : in std_logic_vector ((C_CB_DATA_WIDTH - 1) downto 0);
          O_EMPTY   : out std_logic;
          O_ERROR   : out std_logic
        );
END COMPONENT;

-- DECLARATION: Event Detector
COMPONENT EventDetector
    generic (
        C_ADC_RESOLUTION      : INTEGER := C_ADC_RESOLUTION
    );
    PORT(
        I_ADC1      : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        I_ADC2      : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        I_TRESHOLD1 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        I_TRESHOLD2 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        O_DETECTED  : out STD_LOGIC;
        I_ENABLED   : in STD_LOGIC
    );
END COMPONENT;

-- Signals
signal S_ADC1_READY         : STD_LOGIC; 
signal S_ADC2_READY         : STD_LOGIC; 
signal S_ADC1_VALUE         : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
signal S_ADC2_VALUE         : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);

BEGIN

    ADCReader1: ADCReader PORT MAP (
        I_RST => I_RST,
        I_CLK => I_CLK,
        I_VALUE_READY => I_ADC1_READY,
        I_VALUE => I_ADC1_VALUE,
        O_VALUE => S_ADC1_VALUE,
        O_VALUE_READY => S_ADC1_READY
    );
    
    ADCReader2: ADCReader PORT MAP (
        I_RST => I_RST,
        I_CLK => I_CLK,
        I_VALUE_READY => I_ADC2_READY,
        I_VALUE => I_ADC2_VALUE,
        O_VALUE => S_ADC2_VALUE,
        O_VALUE_READY => S_ADC2_READY
    );

END Behavioral;
