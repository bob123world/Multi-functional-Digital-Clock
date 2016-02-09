--------------------------------------------------------------------------------
-- Company:		Artesis
-- Engineer:	Kaj Van der Hallen
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_debouncing IS
END tb_debouncing;
 
ARCHITECTURE behavior OF tb_debouncing IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debouncer
    PORT(
         clk : IN  std_logic;
         clk100Hz : IN  std_logic;
         b1 : IN  std_logic;
         b2 : IN  std_logic;
         b3 : IN  std_logic;
         b4 : IN  std_logic;
         b1_d : OUT  std_logic;
         b2_d : OUT  std_logic;
         b3_d : OUT  std_logic;
         b4_d : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal clk100Hz : std_logic := '0';
   signal b1 : std_logic := '0';
   signal b2 : std_logic := '0';
   signal b3 : std_logic := '0';
   signal b4 : std_logic := '0';

 	--Outputs
   signal b1_d : std_logic;
   signal b2_d : std_logic;
   signal b3_d : std_logic;
   signal b4_d : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1ms;
   constant clk100Hz_period : time := 10ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debouncer PORT MAP (
          clk => clk,
          clk100Hz => clk100Hz,
          b1 => b1,
          b2 => b2,
          b3 => b3,
          b4 => b4,
          b1_d => b1_d,
          b2_d => b2_d,
          b3_d => b3_d,
          b4_d => b4_d
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   clk100Hz_process :process
   begin
		clk100Hz <= '0';
		wait for clk100Hz_period - clk_period;
		clk100Hz <= '1';
		wait for clk_period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		--wait for 100ms;	
		
		--Statisch
		b1 <= '1';
		
		--bounce simulatie
		b2 <= '1';
		wait for 5 ms;
		b2 <= '0';
		wait for 8 ms;
		b2 <= '1';
		wait for 10 ms;
		b2 <= '0';
		wait for 10 ms;
		b2 <= '1';
		wait for 20 ms;
		b2 <= '0';
		wait for 20 ms;
		b2 <= '1';
		
		--stap
		wait for 500 ms;
		b3 <= '1';
		
		--korte puls
		wait for 100 ms;
		b4 <= '1';
		wait for 20 ms;
		b4 <= '0';

      wait;
   end process;



END;