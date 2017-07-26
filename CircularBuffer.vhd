library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CircularBuffer is
generic ( C_DATA_WIDTH  : INTEGER := 10;	-- Size of an item in bits
      	 C_SIZE     : INTEGER := 20;	-- Size of Ciruclar Buffer. NOTE: Maximum is (2^C_COUNTER_BITS - 1).
	       C_COUNTER_BITS	: INTEGER := 7		-- Number of bits used for internal counter.
	);

port (  I_CLK : in std_logic;
        I_ENR : in std_logic;   					-- Enable read,should be '0' when not in use.
        I_ENW : in std_logic;
	O_SIZE : out std_logic_vector((C_COUNTER_BITS - 1) downto 0); 	-- Enable write,should be '0' when not in use.
        O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);    	-- Output data
        I_DATA : in std_logic_vector ((C_DATA_WIDTH - 1) downto 0);     -- Input data
        O_EMPTY : out std_logic;     					-- '1' if the queue is empty
        O_ERROR: out std_logic                -- `1` if no more elements to read
         );
end CircularBuffer;

architecture Behavioral of CircularBuffer is
	type T_MEMORY is array (0 to (C_SIZE - 1)) of std_logic_vector((C_DATA_WIDTH - 1) downto 0);
	signal S_MEMORY : T_MEMORY :=(others => (others => '0'));   						-- Memory for queue.
	signal S_READ_PTR, S_WRITE_PTR : std_logic_vector((C_COUNTER_BITS - 1) downto 0) := (others => '0'); 	-- Read and write pointers.
	signal S_SIZE : std_logic_vector((C_COUNTER_BITS - 1) downto 0) := (others => '0');			-- Current size of the buffer

begin
	O_SIZE <= S_SIZE;

	process(I_CLK) begin
		-- FUNCTION: Reading
		if (I_CLK'event and I_CLK = '1' and I_ENR = '1') then
			O_DATA <= S_MEMORY(conv_integer(S_READ_PTR));

              if (S_SIZE = 0) then
                O_ERROR <= '1';
              else
			   S_READ_PTR <= S_READ_PTR + '1';
			   S_SIZE <= S_SIZE - '1';
                O_ERROR <= '0';
            end if;
		end if;

		-- FUNCTION: Writting
		if (I_CLK'event and I_CLK = '1' and I_ENW = '1') then
  	   S_MEMORY(conv_integer(S_WRITE_PTR)) <= I_DATA;
  	   S_WRITE_PTR <= S_WRITE_PTR + '1';

       -- If Full
       if (S_SIZE >= C_SIZE - 1) then
         S_READ_PTR <= S_READ_PTR + '1';
       else
         S_SIZE <= S_SIZE + '1';
       end if;
		end if;

		

		-- Reset state of read pointer
		if (S_READ_PTR = C_SIZE) then
			S_READ_PTR <= (others => '0');
		end if;

    -- Reset state of write pointer
		if (S_WRITE_PTR = C_SIZE) then
			S_WRITE_PTR <= (others => '0');
		end if;
		
		-- STATUS: Is Empty
        if (S_WRITE_PTR = S_READ_PTR) then
            O_EMPTY <= '1';
        else
            O_EMPTY <= '0';
        end if;
	end process;

end Behavioral;
