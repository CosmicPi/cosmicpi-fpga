library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity ADC_Reader is
    Generic (
      C_RESOLUTION      : in STD_LOGIC_VECTOR (5 downto 0) := 10
    );

    Port (I_CLK           : in STD_LOGIC;
          I_RST           : in STD_LOGIC;
          I_VALUE      : in STD_LOGIC_VECTOR (7 downto 0)
    );
end ADC_Reader;



architecture Behavioral of ADC_Reader is
 
-- Constants
constant ADC_RESOLUTION : unsigned(5 downto 0) := unsigned(C_RESOLUTION);

-- Signals
signal S_Sample: STD_LOGIC_VECTOR(7 downto 0);
 
begin
end Behavioral;