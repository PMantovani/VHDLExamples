library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab8 is
	generic ( T : integer := 500);
   Port ( keyboard : in  STD_LOGIC_VECTOR (3 downto 0);
			 reset : in STD_LOGIC;
			 clk : in STD_LOGIC;
          unlocked_led : out  STD_LOGIC;
          idle_led : out  STD_LOGIC);
end lab8;

architecture Behavioral of lab8 is

type state is (e0, e1, e2, e3, e4, e5);
attribute enum_encoding: string;
attribute enum_encoding of state: type is "sequential";
signal current_s, next_s : state;
signal digit1, digit2, digit3 : integer range 0 to 9;
signal counter : integer range 0 to T := 0;
signal timeout : STD_LOGIC := '0';

begin

process (clk, reset)
begin
	if (reset = '1' or counter = T) then 
		current_s <= e0;
		counter <= 0;
		timeout <= '0';
	elsif (rising_edge(clk)) then
		-- if the state has changed, reset the counter
		if (current_s /= next_s) then
			counter <= 0;
		else
			counter <= counter + 1;
		end if;
		-- move to next state
		current_s <= next_s;
		
		-- check if we reached our timeout
		if (counter = T-1) then
			timeout <= '1';
		end if;
	end if;
end process;

process (current_s, keyboard, timeout)
begin
	case current_s is
		-- idle state
		when e0 =>
			idle_led <= '1';
			unlocked_led <= '0';
			-- first digit pressed
			if (keyboard /= "1111") then
				digit1 <= to_integer(unsigned(keyboard));
				idle_led <= '0';
				next_s <= e1; 
			end if;
		-- debouncing state
		when e1 =>
			if (keyboard = "1111") then
				next_s <= e2;
			end if;
		-- waiting for second digit press
		when e2 =>
			-- second digit pressed
			if (keyboard /= "1111") then
				digit2 <= to_integer(unsigned(keyboard));
				next_s <= e3;
			-- timeout
			elsif (timeout = '1') then
				next_s <= e0;
			end if;
		-- second debouncing state
		when e3 =>
			if (keyboard = "1111") then
				next_s <= e4;
			end if;
		-- waiting for third digit press
		when e4 =>
			-- third digit pressed
			if (keyboard /= "1111") then
				digit3 <= to_integer(unsigned(keyboard));
				-- check if correct password
				if (digit1 = 1 and digit2 = 2 and to_integer(unsigned(keyboard)) = 3) then
					idle_led <= '0';
					unlocked_led <= '1';
					next_s <= e5;
				-- wrong password
				else
					next_s <= e0;
				end if;
			-- timeout
			elsif (timeout = '1') then
				next_s <= e0;
			end if;
		when e5 =>
			-- unlocked state
			if (timeout = '1') then
				next_s <= e0;
			end if;
	end case;
end process;

end Behavioral;

