library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Main is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC
    );
end Main;

architecture Behavioral of Main is

signal S_Test: STD_LOGIC;

begin

S_Test <= iCLK;

end Behavioral;
