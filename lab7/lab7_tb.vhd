--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY lab7_tb IS
END lab7_tb;
 
ARCHITECTURE behavior OF lab7_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cont
    PORT(
         clk : IN  std_logic;
         pause : IN  std_logic;
         reset : IN  std_logic;
         showHours : IN  std_logic;
         display : OUT  std_logic_vector(6 downto 0);
         enableDisplay : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs 
   signal clk : std_logic := '0';
   signal pause : std_logic := '0';
   signal reset : std_logic := '0';
   signal showHours : std_logic := '0';

	--BiDirs
   signal enableDisplay : std_logic_vector(3 downto 0);
 
 	--Outputs
   signal display : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN  
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cont PORT MAP (
          clk => clk,
          pause => pause,
          reset => reset,
          showHours => showHours,
          display => display,
          enableDisplay => enableDisplay
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

      -- insert stimulus here 
		wait for 1000ms;
		reset <= '1';
		wait for 1000ms;
		reset <= '0';
		wait for 1000ms;
		pause <= '1';
		wait for 1000ms;
		pause <= '0';
		wait for 1000ms;
		showHours <= '1';
		wait for 1000ms;
		showHours <= '0';

      wait;
   end process;

END;
 