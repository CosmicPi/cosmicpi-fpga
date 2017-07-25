library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Based on: http://vhdlguru.blogspot.ch/2010/03/basic-model-of-fifo-queue-in-vhdl.html
entity FIFO is
generic (
      C_DATA_WIDTH      : INTEGER := 10;
      C_DATA_SIZE      	: INTEGER := 20
	);

port (  I_CLK : in std_logic;
        I_ENR : in std_logic;   										-- Enable read,should be '0' when not in use.
        I_ENW : in std_logic;    										-- Enable write,should be '0' when not in use.
        O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);    	-- Output data
        I_DATA : in std_logic_vector ((C_DATA_WIDTH - 1) downto 0);     -- Input data
        O_EMPTY : out std_logic;     									-- Set as '1' when the queue is empty
        O_FULL : out std_logic     										-- Set as '1' when the queue is full
         );
end FIFO;

architecture Behavioral of FIFO is
	type T_MEMORY is array (0 to (C_DATA_SIZE - 1)) of std_logic_vector((C_DATA_WIDTH - 1) downto 0);
	signal S_MEMORY : T_MEMORY :=(others => (others => '0'));   					-- Memory for queue.
	signal S_READ_PTR, S_WRITE_PTR : std_logic_vector(7 downto 0) := (others => '0'); 	-- Read and write pointers.
	
begin
	process(I_CLK) begin
		if (I_CLK'event and I_CLK = '1' and I_ENR = '1') then
			O_DATA <= S_MEMORY(conv_integer(S_READ_PTR));
			S_READ_PTR <= S_READ_PTR + '1';      -- Points to next address.
		end if;
		
		if(I_CLK'event and I_CLK = '1' and I_ENW = '1') then
			S_MEMORY(conv_integer(S_WRITE_PTR)) <= I_DATA;
			S_WRITE_PTR <= S_WRITE_PTR + '1';  	-- Points to next address.
		end if;
		
		if (S_READ_PTR = C_DATA_SIZE) then      	-- Resetting read pointer.
			S_READ_PTR <= (others => '0');
		end if;
		
		if (S_WRITE_PTR = C_DATA_SIZE) then       -- Checking whether queue is full or not
			O_FULL <='1';
			S_WRITE_PTR <= (others => '0');
		else
			O_FULL <='0';
		end if;
		
		if (S_WRITE_PTR = 0) then   	-- Checking whether queue is empty or not
			O_EMPTY <='1';
		else
			O_EMPTY <='0';
		end if;
	end process;

end Behavioral;
