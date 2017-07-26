LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all; 

ENTITY CircularBuffer_tb IS
END CircularBuffer_tb;

ARCHITECTURE behavior OF CircularBuffer_tb IS

    constant C_DATA_WIDTH  : INTEGER := 10;
    constant C_SIZE     : INTEGER := 20;
    constant C_COUNTER_BITS	: INTEGER := 8;
    constant iCLK_period : time := 10 ns;


    COMPONENT CircularBuffer
    generic ( C_DATA_WIDTH  : INTEGER := C_DATA_WIDTH;	-- Size of an item in bits
          	 C_SIZE     : INTEGER := C_SIZE;	-- Size of Ciruclar Buffer. NOTE: Maximum is (2^C_COUNTER_BITS - 1).
    	       C_COUNTER_BITS	: INTEGER := C_COUNTER_BITS		-- Number of bits used for internal counter.
    	);
    PORT(
          I_CLK           : in STD_LOGIC;
          I_ENR : in std_logic;   					-- Enable read,should be '0' when not in use.
          I_ENW : in std_logic;
          O_SIZE : out std_logic_vector((C_COUNTER_BITS - 1) downto 0); 	-- Enable write,should be '0' when not in use.
          O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);    	-- Output data
          I_DATA : in std_logic_vector ((C_DATA_WIDTH - 1) downto 0);     -- Input data
          O_EMPTY : out std_logic;     					-- '1' if the queue is empty
          O_ERROR: out std_logic
        );
    END COMPONENT;

   signal I_CLK : STD_LOGIC := '0';
   signal I_ENR : std_logic := '0';   					   -- Enable read,should be '0' when not in use.
   signal I_ENW : std_logic := '0';
   signal O_SIZE : std_logic_vector((C_COUNTER_BITS - 1) downto 0) := (others => '0'); 	  -- Enable write,should be '0' when not in use.
   signal O_DATA : std_logic_vector((C_DATA_WIDTH - 1) downto 0) := (others => '0');    	-- Output data
   signal I_DATA : std_logic_vector ((C_DATA_WIDTH - 1) downto 0) := (others => '0');     -- Input data
   signal O_EMPTY : std_logic := '0';     					-- '1' if the queue is empty
   signal O_ERROR: std_logic := '0';

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: CircularBuffer PORT MAP (
          I_CLK => I_CLK,
          I_ENR => I_ENR,
          I_ENW => I_ENW,
          O_SIZE => O_SIZE,
          O_DATA => O_DATA,
          I_DATA => I_DATA,
          O_EMPTY => O_EMPTY,
          O_ERROR => O_ERROR
        );

   -- Clock process definitions
   iCLK_process: process begin
		I_CLK <= '0';
		wait for iCLK_period/2;
		I_CLK <= '1';
		wait for iCLK_period/2;
   end process;


    -- Stimulus process
    stim_proc: process begin
        -- TEST: (SWSR) Single write, single read
        -- Write data
        I_ENW <= '1';
        I_DATA <= "1000010000";
        wait for iCLK_period;
        I_ENW <= '0';
        wait for iCLK_period;
        assert (to_integer(unsigned(O_SIZE)) = 1) report "SWSR: failed! Size should be 1" severity error;
        
        -- Read data
        I_ENR <= '1';
        wait for iCLK_period;
        -- TODO: Ask if 1 clock delay is OK
        assert (O_DATA = "1000010000") report "SWSR: failed! Read and written values are not same" severity error;
        assert (O_ERROR = '0') report "SWSR: failed! Error flag should `0`" severity error;
        assert (to_integer(unsigned(O_SIZE)) = 0) report "SWSR: failed! Size after read should be 0" severity error;
        I_ENR <= '0';
        wait for iCLK_period;
        
        
        -- TEST: (MWSR) Multiple write (more than 20 writes), single read
        -- Write data
         for  i in 0 to 22 loop
             I_ENW <= '1';
             I_DATA <= std_logic_vector(to_unsigned(i, C_DATA_WIDTH));
             wait for iCLK_period;
             I_ENW <= '0';
             wait for iCLK_period;
         end loop;
         
        assert (to_integer(unsigned(O_SIZE)) = 19) report "MWSR: failed! Maximal buffer size is 19 (20 items - 1 reserved item)" severity error;
         
        -- Read data
        I_ENR <= '1';
        wait for iCLK_period;
        assert (to_integer(unsigned(O_DATA)) = 4) report "MWSR: failed! Read and written values are not same" severity error;
        assert (O_ERROR = '0') report "MWSR: failed! Error flag should `0`" severity error;
        I_ENR <= '0';
        wait for iCLK_period;
        
        
        
        -- TEST: (MR) Multiple read (more than 20 reads)
        for  i in 0 to 22 loop
            I_ENR <= '1';
            wait for iCLK_period;
            I_ENR <= '0';
            wait for iCLK_period;
        end loop;
        assert (O_ERROR = '1') report "MR: failed! Error flag should `0`" severity error;
        assert (to_integer(unsigned(O_SIZE)) = 0) report "MR: failed! Size after read should be 0" severity error;

        
        wait;
    end process;

END;
