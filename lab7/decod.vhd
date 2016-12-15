--------------------------------------------------
-- Laboratório 6
-- 
-- Aluno: Pedro Bosquiero da Silva	GRR 20136205
-- Aluno: Pedro Mantovani Antunes	GRR 20133893
--------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decod is
   Port ( value : in  integer range 0 to 9;
           seven_seg : out  STD_LOGIC_VECTOR (6 downto 0));
end decod;

architecture Behavioral of decod is

begin

seven_seg <= 	"0000001" when value = 0 else 
					"1001111" when value = 1 else 
					"0010010" when value = 2 else 
					"0000110" when value = 3 else 
					"1001100" when value = 4 else 
					"0100100" when value = 5 else 
					"0100000" when value = 6 else 
					"0001111" when value = 7 else 
					"0000000" when value = 8 else 
					"0000100";

end Behavioral;