library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Source: http://www.latticesemi.com/~/media/LatticeSemi/Documents/ApplicationNotes/MO/MemoryUsageGuideforiCE40Devices.pdf?document_id=47775 (page 20)
entity lattice_ram is
  generic (
    addr_width : natural := 8;
    data_width : natural := 16
  );

  port (
    addr : in std_logic_vector (addr_width - 1 downto 0);
    write_en : in std_logic;
    clk : in std_logic;
    din : in std_logic_vector (data_width - 1 downto 0);
    dout : out std_logic_vector (data_width - 1 downto 0)
  );
end lattice_ram;

architecture rtl of lattice_ram is
  type mem_type is array ((2** addr_width) - 1 downto 0) of
  std_logic_vector(data_width - 1 downto 0);
  signal mem : mem_type;

begin
  process (clk) begin
    if (clk'event and clk = '1') then
      if (write_en = '1') then
        mem(conv_integer(addr)) <= din;
      end if;

      dout <= mem(conv_integer(addr));
    end if;
  end process;
end rtl;
