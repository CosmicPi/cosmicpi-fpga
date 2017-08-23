library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EventStack is
  generic (
    C_NUMBER_OF_SAMPLES : integer := 20;
    C_DATA_WIDTH        : integer := 16
  );

  port (
    I_CLK : in std_logic;
    I_PPS : in std_logic;
    I_DETECTED : in std_logic;
    I_DATA : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
    O_DATA : out std_logic_vector((C_DATA_WIDTH - 1) downto 0)
  );
end EventStack;

architecture Behavioral of EventStack is

constant addr_width : natural := 8;
constant data_width : natural := 16;

COMPONENT lattice_ram
  generic (
    addr_width : natural := 8;
    data_width : natural := 16
  );
  PORT (
    addr : in std_logic_vector (addr_width - 1 downto 0);
    write_en : in std_logic;
    clk : in std_logic;
    din : in std_logic_vector (data_width - 1 downto 0);
    dout : out std_logic_vector (data_width - 1 downto 0)
  );
END COMPONENT;

signal S_STORE_ENABLED : std_logic := '0';

-- We use two RAMs for double buffering
signal S_RAM_ADDRESS_A      : std_logic_vector (addr_width - 1 downto 0);
signal S_RAM_WRITE_ENABLE_A : std_logic;
signal S_RAM_DATA_IN_A      : std_logic_vector (data_width - 1 downto 0);
signal S_RAM_DATA_OUT_A     : std_logic_vector (data_width - 1 downto 0);

signal S_RAM_ADDRESS_B      : std_logic_vector (addr_width - 1 downto 0);
signal S_RAM_WRITE_ENABLE_B : std_logic;
signal S_RAM_DATA_IN_B      : std_logic_vector (data_width - 1 downto 0);
signal S_RAM_DATA_OUT_B     : std_logic_vector (data_width - 1 downto 0);

signal S_SWITCH             : std_logic := '0';
signal S_RAM_READ_ADDRESS   : std_logic_vector (addr_width - 1 downto 0);
signal S_RAM_WRITE_ADDRESS  : std_logic_vector (addr_width - 1 downto 0);

signal S_EVENT_SAMPLES_N    : std_logic_vector(7 downto 0) := (others => '0');

begin
  LatticeRAM_A: lattice_ram PORT MAP (
       addr => S_RAM_ADDRESS_A,
       write_en => S_RAM_WRITE_ENABLE_A,
       clk => I_CLK,
       din => S_RAM_DATA_IN_A,
       dout => S_RAM_DATA_OUT_A
     );

   LatticeRAM_B: lattice_ram PORT MAP (
        addr => S_RAM_ADDRESS_B,
        write_en => S_RAM_WRITE_ENABLE_B,
        clk => I_CLK,
        din => S_RAM_DATA_IN_B,
        dout => S_RAM_DATA_OUT_B
      );

  -- When `S_SWITCH == '1'` then: A read, B write
  S_RAM_ADDRESS_A <= S_RAM_READ_ADDRESS when (S_SWITCH = '1') else
        S_RAM_WRITE_ADDRESS;
  S_RAM_ADDRESS_B <= S_RAM_READ_ADDRESS when (S_SWITCH = '0') else
        S_RAM_WRITE_ADDRESS;
  S_RAM_DATA_IN_A <= I_DATA when (S_SWITCH = '0') else
        S_RAM_DATA_IN_B;
  O_DATA <= S_RAM_DATA_OUT_A when (S_SWITCH = '1') else
        S_RAM_DATA_OUT_B;
  S_RAM_WRITE_ENABLE_A <= '1' when (S_SWITCH = '0' and S_STORE_ENABLED = '1') else
      '0';
  S_RAM_WRITE_ENABLE_B <= '1' when (S_SWITCH = '1' and S_STORE_ENABLED = '1') else
      '0';

  process (I_PPS) begin
      if (I_PPS = '1') then
          S_SWITCH <= not S_SWITCH;
          S_RAM_READ_ADDRESS <= (others => '0');
          S_RAM_WRITE_ADDRESS <= (others => '0');
          S_EVENT_SAMPLES_N <= (others => '0');
      end if;
  end process;

  process (I_DETECTED) begin
    if (I_DETECTED = '1') then
        S_STORE_ENABLED <= '1';
    end if;
  end process;

	process (I_CLK) begin
      if (I_CLK'event and I_CLK = '1') then
          if (S_STORE_ENABLED = '1') then
            S_RAM_WRITE_ADDRESS <= S_RAM_WRITE_ADDRESS + 1;
            S_EVENT_SAMPLES_N <= S_EVENT_SAMPLES_N + 1;
          end if;

          if (to_integer(unsigned(S_EVENT_SAMPLES_N)) > 20) then
              S_EVENT_SAMPLES_N <= (others => '0');
              S_STORE_ENABLED <= '0';
          end if;
      end if;
  end process;

end Behavioral;
