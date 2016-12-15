LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY lab8_tb IS
END lab8_tb;
 
ARCHITECTURE behavior OF lab8_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lab8
    PORT(
         keyboard : IN  std_logic_vector(3 downto 0);
         reset : IN  std_logic;
         clk : IN  std_logic;
         unlocked_led : OUT  std_logic;
         idle_led : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal keyboard : std_logic_vector(3 downto 0) := (others => '1');
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal unlocked_led : std_logic;
   signal idle_led : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lab8 PORT MAP (
          keyboard => keyboard,
          reset => reset,
          clk => clk,
          unlocked_led => unlocked_led,
          idle_led => idle_led
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- success case
		keyboard <= "0001";
		wait for 1us;
		keyboard <= "1111";
		wait for 1us;

		keyboard <= "0010";
		wait for 1us;
		keyboard <= "1111";
		wait for 1us;
		
		keyboard <= "0011";
		wait for 1us;
		keyboard <= "1111";
		wait for 10us;
		
		-- timeout after first digit
		reset <= '1';
		keyboard <= "1111";
		wait for 1us;
		reset <= '0';
		keyboard <= "0001";
		wait for 1us;
		keyboard <= "1111";
		wait for 10us;

      wait;
   end process;

END;
