library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY LinearBuffer_tb IS
END LinearBuffer_tb;

ARCHITECTURE behavior OF LinearBuffer_tb IS
    constant C_DATA_WIDTH : INTEGER := 10; 

    COMPONENT LinearBuffer
    PORT(
        I_CLK : in std_logic;
        I_DATA : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
        O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0)
        );
    END COMPONENT;


   signal I_CLK             : STD_LOGIC := '0';
   signal O_DATA           : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
   signal I_DATA           : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');

   constant C_CLK_PERIOD : time := 10 ns;

BEGIN

   uut: LinearBuffer PORT MAP (
          I_CLK => I_CLK,
          O_DATA => O_DATA,
          I_DATA => I_DATA
        );

   ClockGeneratorProcess: process begin
		I_CLK <= '0';
		wait for C_CLK_PERIOD / 2;
		I_CLK <= '1';
		wait for C_CLK_PERIOD / 2;
   end process;


   SimulationProcess: process begin
     for i in 0 to 30 loop
      I_DATA <= STD_LOGIC_VECTOR(to_unsigned(i, 10));
      wait for C_CLK_PERIOD;
    end loop;


      wait;
   end process;

END;
