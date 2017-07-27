library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EventDetector is
  generic (
    C_ADC_RESOLUTION      : INTEGER := 10
  );

    port (
      I_ADC1        : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
      I_ADC2        : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
      I_TRESHOLD1   : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
      I_TRESHOLD2   : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
      O_DETECTED    : out STD_LOGIC;
      I_ENABLED     : in STD_LOGIC
    );
end EventDetector;


architecture Behavioral of EventDetector is

begin
  O_DETECTED <= '1' when (I_ENABLED = '1' and
    to_integer(unsigned(I_ADC1)) > to_integer(unsigned(I_TRESHOLD1)) and
    to_integer(unsigned(I_ADC2)) > to_integer(unsigned(I_TRESHOLD2))) else
    '0';
end Behavioral;
