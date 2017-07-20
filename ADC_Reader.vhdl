library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Provides an abstraction layer on of physicaly ADC.
-- NOTE: Generally this module is redundant, but it provides abstraction on top of hardware.

entity ADC_Reader is
    generic (
      C_RESOLUTION      : in STD_LOGIC_VECTOR (5 downto 0) := 10
    );

    port (I_CLK           : in STD_LOGIC;
          I_RST           : in STD_LOGIC;
          I_VALUE_READY         : in STD_LOGIC;
          I_VALUE      : in STD_LOGIC_VECTOR ((C_RESOLUTION - 1) downto 0);
          O_VALUE_READY  : out STD_LOGIC;
          O_VALUE        : out STD_LOGIC
    );
end ADC_Reader;


architecture Behavioral of ADC_Reader is

-- Constants
constant ADC_RESOLUTION : unsigned(5 downto 0) := unsigned(C_RESOLUTION);

begin
  -- ReadyToRead: process (I_READY) begin
  --   if rising_edge(I_READY) then
  --   end if;
  -- end process;

  -- Send to output
  O_VALUE_READY <= I_VALUE_READY;
  O_VALUE <= I_VALUE;
end Behavioral;
