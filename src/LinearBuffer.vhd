library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LinearBuffer is
generic ( C_DATA_WIDTH  : INTEGER := 10;	-- Size of an item in bits
      	 C_SIZE     : INTEGER := 20;	-- Size of Ciruclar Buffer. NOTE: Maximum is (2^C_COUNTER_BITS - 1).
	       C_COUNTER_BITS	: INTEGER := 7		-- Number of bits used for internal counter.
	);
port (  I_CLK : in std_logic;
        I_DATA : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
        O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0)
         );
end LinearBuffer;

architecture Behavioral of LinearBuffer is
	type T_MEMORY is array (0 to (C_SIZE - 1)) of std_logic_vector((C_DATA_WIDTH - 1) downto 0);
	signal S_MEMORY : T_MEMORY :=(others => (others => '0'));

begin
	process (I_CLK) begin
        if (I_CLK'event and I_CLK = '1') then
            -- Write in first register
            S_MEMORY(0) <= I_DATA;
        
            -- Propagate
            RegisterPropagationLoop: for i in (C_SIZE - 2) downto 0 loop
              S_MEMORY(i + 1) <= S_MEMORY(i);
            end loop;
    
            -- Send to output
            O_DATA <= S_MEMORY(C_SIZE - 1);
        end if;
  end process;

end Behavioral;
