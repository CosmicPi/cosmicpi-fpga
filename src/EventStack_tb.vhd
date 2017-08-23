library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY EventStack_tb IS
END EventStack_tb;

ARCHITECTURE behavior OF EventStack_tb IS
    constant C_NUMBER_OF_SAMPLES : integer := 20;
    constant C_DATA_WIDTH        : integer := 16;

    COMPONENT EventStack
    generic (
    C_NUMBER_OF_SAMPLES : integer := C_NUMBER_OF_SAMPLES;
    C_DATA_WIDTH        : integer := C_DATA_WIDTH
        );
    PORT(
        I_CLK : in std_logic;
        I_PPS : in std_logic;
        I_DETECTED : in std_logic;
        I_DATA : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
        O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0)
        );
    END COMPONENT;

    signal I_CLK : std_logic;
    signal I_PPS : std_logic;
    signal I_DETECTED : std_logic;
    signal I_DATA : std_logic_vector((C_DATA_WIDTH - 1) downto 0);
    signal O_DATA : std_logic_vector((C_DATA_WIDTH - 1) downto 0);
    
   constant C_CLK_PERIOD : time := 10 ns;
   
begin
  uut: EventStack PORT MAP (
      I_CLK => I_CLK,
      I_PPS => I_PPS,
      I_DETECTED => I_DETECTED,
      I_DATA => I_DATA,
      O_DATA => O_DATA
     );

   ClockGeneratorProcess: process begin
     I_CLK <= '0';
     wait for C_CLK_PERIOD / 2;
     I_CLK <= '1';
     wait for C_CLK_PERIOD / 2;
   end process;


    SimulationProcess: process begin
      I_DETECTED <= '1';
    for i in 0 to 30 loop
       I_DATA <= STD_LOGIC_VECTOR(to_unsigned(i, C_DATA_WIDTH));
       wait for C_CLK_PERIOD;
    end loop;
     
     I_PPS <= '1';
     wait for C_CLK_PERIOD;
     I_PPS <= '0';
     wait for C_CLK_PERIOD;
     
     for i in 0 to 30 loop
        I_DATA <= STD_LOGIC_VECTOR(to_unsigned(i, C_DATA_WIDTH));
        wait for C_CLK_PERIOD;
     end loop;
    end process;
END;
