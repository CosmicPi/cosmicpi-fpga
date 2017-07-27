library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Top is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC
    );
end Top;

architecture Behavioral of Top is

signal S_Test: STD_LOGIC;

begin

S_Test <= iCLK;

end Behavioral;
