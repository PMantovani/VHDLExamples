--------------------------------------------------
-- Laboratório 7
-- 
-- Aluno: Pedro Bosquiero da Silva	GRR 20136205
-- Aluno: Pedro Mantovani Antunes	GRR 20133893
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--library work;
--use work.converter.all;

entity cont is
	generic (N: integer := 50_000;
				MUX: integer := 50);
   port ( clk : in  std_logic;
			  pause : in std_logic;
			  reset : in std_logic;
			  showHours: in std_logic;
           display : out  std_logic_vector(6 downto 0);
			  enableDisplay : out std_logic_vector(3 downto 0));
end cont;

architecture Behavioral of cont is

component decod is
	port ( value : in integer range 0 to 9;
			 seven_seg : out std_logic_vector(6 downto 0));
end component;

signal digit : integer range 0 to 9;
signal state : integer range 0 to 3 := 0;

-- signals used only to show values in simulation, as ISIM can't show variable values
signal dHourSig : integer;
signal hourSig : integer;
signal dMinSig : integer;
signal minSig : integer;
signal dSecSig : integer;
signal secSig : integer;

begin

process (clk)

	variable divCounter : integer range 0 to N := 0;
	variable counterMux : integer range 0 to MUX := 0;
	variable dHour : integer range 0 to 10 := 0;
	variable hour : integer range 0 to 10 := 0;
	variable dMin : integer range 0 to 6 := 0;
	variable min : integer range 0 to 10 := 0;
	variable dSec : integer range 0 to 6 := 0;
	variable sec : integer range 0 to 10 := 0;

begin
	if (clk'EVENT and clk='1') then
	   if (reset='1') then
			dHour := 0;
			hour := 0;
			dMin := 0;
			min := 0;
			dSec := 0;
			sec := 0;
		end if;
	   if (pause/='1' and reset/='1') then
			divCounter := (divCounter + 1);
			if (divCounter = N) then
			
				sec := sec + 1;
				if (sec = 10) then
					sec := 0;
					dSec := dSec + 1;
					if (dSec = 6) then
						dSec := 0;
						min := min + 1;
						if (min = 10) then
							min := 0;
							dMin := dMin + 1;
							if (dMin = 6) then
								dMin := 0;
								hour := hour + 1;
								if (hour = 10) then
									hour := 0;
									dHour := dHour + 1;
									if (dHour = 10) then
										dHour := 0;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
				
				divCounter := 0;
			end if;
		end if;
		
		-- Display multiplex rate = 1kHz
		counterMux := (counterMux + 1);
		if (counterMux = MUX) then
			case state is 
				when 0 =>
					enableDisplay <= "0111";
					state <= 1;
				when 1 =>
					enableDisplay <= "1011";
					state <= 2;
				when 2 =>
					enableDisplay <= "1101";
					state <= 3;
				when others =>
					enableDisplay <= "1110";
					state <= 0;
			end case;
			counterMux := 0;
		end if;
		
		if (showHours = '1') then
			case state is
				when 1 => digit <= dHour;
				when 2 => digit <= hour;
				when 3 => digit <= dMin;
				when others => digit <= min;
			end case;
		else 
			case state is
				when 1 => digit <= dMin;
				when 2 => digit <= min;
				when 3 => digit <= dSec;
				when others => digit <= sec;
			end case;
		end if;
	
	-- Assigns signal value to variable value
	dHourSig <= dHour;
	hourSig <= hour;
	dMinSig <= dMin;
	minSig <= min;
	dSecSig <= dSec;
	secSig <= sec;
	
	end if;
	
end process;

-- Decodifica o digito para 7 segmentos
lab: decod port map (value => digit, seven_seg => display);

end Behavioral;