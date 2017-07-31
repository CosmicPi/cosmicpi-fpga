library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Top is
     generic (
        -- Constants    
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

-- Candidates to be put in separated module
signal S_EVENT_DETECTED     : STD_LOGIC;
-- TODO: Treshold configuration module or to built in EventDetector module
signal S_TRESHOLD1          : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := STD_LOGIC_VECTOR(to_unsigned(100, C_ADC_RESOLUTION));
signal S_TRESHOLD2          : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0) := STD_LOGIC_VECTOR(to_unsigned(100, C_ADC_RESOLUTION));

signal S_CB1_ERROR          : STD_LOGIC;
signal S_CB2_ERROR          : STD_LOGIC;
signal S_CB1_EMPTY          : STD_LOGIC;
signal S_CB2_EMPTY          : STD_LOGIC;
signal S_CB1_SIZE           : STD_LOGIC_VECTOR((C_CB_COUNTER_BITS - 1) downto 0);
signal S_CB2_SIZE           : STD_LOGIC_VECTOR((C_CB_COUNTER_BITS - 1) downto 0);
signal S_CB1_DATA           : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
signal S_CB2_DATA           : STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);

BEGIN
    iADCReader1: ADCReader PORT MAP (
        I_RST => I_RST,
        I_CLK => I_CLK,
        I_VALUE_READY => I_ADC1_READY,
        I_VALUE => I_ADC1_VALUE,
        O_VALUE => S_ADC1_VALUE,
        O_VALUE_READY => S_ADC1_READY
    );
    
    iADCReader2: ADCReader PORT MAP (
        I_RST => I_RST,
        I_CLK => I_CLK,
        I_VALUE_READY => I_ADC2_READY,
        I_VALUE => I_ADC2_VALUE,
        O_VALUE => S_ADC2_VALUE,
        O_VALUE_READY => S_ADC2_READY
    );
    
    iEventDetector: EventDetector PORT MAP (
        I_ADC1  => S_ADC1_VALUE,
        I_ADC2  => S_ADC2_VALUE,
        I_TRESHOLD1 => S_TRESHOLD1, 
        I_TRESHOLD2 => S_TRESHOLD2,
        O_DETECTED  => S_EVENT_DETECTED,
        I_ENABLED   => '1'
    );
    
    iCircularBuffer1: CircularBuffer PORT MAP (
        I_CLK => I_CLK,
        I_ENR => '0',
        I_ENW => S_ADC1_READY,
        O_SIZE => S_CB1_SIZE,
        O_DATA => S_CB1_DATA,
        I_DATA => S_ADC1_VALUE,
        O_EMPTY => S_CB1_EMPTY,
        O_ERROR => S_CB1_ERROR
    );
    
    iCircularBuffer2: CircularBuffer PORT MAP (
        I_CLK => I_CLK,
        I_ENR => '0',
        I_ENW => S_ADC2_READY,
        O_SIZE => S_CB2_SIZE,
        O_DATA => S_CB2_DATA,
        I_DATA => S_ADC2_VALUE,
        O_EMPTY => S_CB2_EMPTY,
        O_ERROR => S_CB2_ERROR
    );
    

END Behavioral;
