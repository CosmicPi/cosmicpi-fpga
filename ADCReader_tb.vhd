LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ADCReader_tb IS
END ADCReader_tb;
 
ARCHITECTURE behavior OF ADCReader_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ADCReader
    PORT(
         I_CLK           : in STD_LOGIC;
          I_RST           : in STD_LOGIC;
          I_VALUE_READY    : in STD_LOGIC;
          O_VALUE_READY  : out STD_LOGIC;
	I_VALUE      : in STD_LOGIC_VECTOR (9 downto 0);
	O_VALUE        : out STD_LOGIC_VECTOR (9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : STD_LOGIC := '0';
   signal I_RST : STD_LOGIC := '0';
   signal I_VALUE_READY : STD_LOGIC := '0';
   signal I_VALUE : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";

 --Outputs
   signal O_VALUE_READY : STD_LOGIC;
   signal O_VALUE        : STD_LOGIC_VECTOR (9 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ADCReader PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_VALUE_READY => I_VALUE_READY,
          O_VALUE => O_VALUE,
          O_VALUE_READY => O_VALUE_READY,
          I_VALUE => I_VALUE
        );

   -- Clock process definitions
   iCLK_process :process
   begin
		I_CLK <= '0';
		wait for iCLK_period/2;
		I_CLK <= '1';
		wait for iCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		I_VALUE <= "1000010000";	
		I_VALUE_READY <= '0';

		wait for 50ns;

		I_VALUE <= "0000010000";	
		I_VALUE_READY <= '1';

      wait;
   end process;

END;
