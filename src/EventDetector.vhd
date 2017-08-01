library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Purpose of EventDetector is to detect a peak which means that scintillation is hit by cosmic ray. 
-- Peak is detected when series (`I_SAMPLES`) of ADC measurements are greter than threshold. 
entity EventDetector is
    generic (
        C_ADC_RESOLUTION        : INTEGER := 10;
        C_PEAK_TIME_RESOLUTION  : INTEGER := 8
    );

    port (
        I_CLK       : in STD_LOGIC;
        I_RST       : in STD_LOGIC;
        I_SAMPLES   : in STD_LOGIC_VECTOR ((C_PEAK_TIME_RESOLUTION - 1) downto 0);
        I_ADC1      : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        I_ADC2      : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        I_TRESHOLD1 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        I_TRESHOLD2 : in STD_LOGIC_VECTOR ((C_ADC_RESOLUTION - 1) downto 0);
        O_DETECTED  : out STD_LOGIC;
        I_ENABLED   : in STD_LOGIC
    );
end EventDetector;

architecture Behavioral of EventDetector is
    signal S_N_SAMPLES  : STD_LOGIC_VECTOR ((C_PEAK_TIME_RESOLUTION - 1) downto 0) := (others => '0');
    
begin
    MainProcess: process (I_CLK, I_RST) begin
        if (I_RST = '0') then
               S_N_SAMPLES <= (others => '0');
        elsif (rising_edge(I_CLK)) then
            if (to_integer(unsigned(I_ADC1)) > to_integer(unsigned(I_TRESHOLD1)) and
                to_integer(unsigned(I_ADC2)) > to_integer(unsigned(I_TRESHOLD2))) then
                S_N_SAMPLES <= S_N_SAMPLES + 1;
            else
                S_N_SAMPLES <= (others => '0');
            end if;    
        end if;
    end process;
    
    O_DETECTED <= '1' when (to_integer(unsigned(S_N_SAMPLES)) >= to_integer(unsigned(I_SAMPLES))) else
                '0';
end Behavioral;
