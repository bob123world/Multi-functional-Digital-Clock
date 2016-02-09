--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:17:16 11/14/2012
-- Design Name:   
-- Module Name:   C:/Users/Michael/Documents/Elektronica-ICT/Lab Programeerbare Digitale Systemen 3/Project/Xilinx/Gino/tb_toplevel.vhd
-- Project Name:  Gino
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: toplevel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_toplevel IS
END tb_toplevel;
 
ARCHITECTURE behavior OF tb_toplevel IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT toplevel
    PORT(
         clk25MHz : IN  std_logic;
         clk100Hz : IN  std_logic;
         clk1Hz : IN  std_logic;
         But1 : IN  std_logic;
         But2 : IN  std_logic;
         But3 : IN  std_logic;
         But4 : IN  std_logic;
         C1 : OUT  std_logic_vector(3 downto 0);
         C2 : OUT  std_logic_vector(3 downto 0);
         C4 : OUT  std_logic_vector(3 downto 0);
         C5 : OUT  std_logic_vector(3 downto 0);
         C7 : OUT  std_logic_vector(3 downto 0);
         C8 : OUT  std_logic_vector(3 downto 0);
         Vsel : OUT  std_logic_vector(2 downto 0);
         Vselseg : OUT  std_logic_vector(1 downto 0);
         Wac : OUT  std_logic;
         Alac : OUT  std_logic;
         feS : OUT  std_logic_vector(3 downto 0);
         ftS : OUT  std_logic_vector(3 downto 0);
         feM : OUT  std_logic_vector(3 downto 0);
         ftM : OUT  std_logic_vector(3 downto 0);
         feH : OUT  std_logic_vector(3 downto 0);
         ftH : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk25MHz : std_logic := '0';
   signal clk100Hz : std_logic := '0';
   signal clk1Hz : std_logic := '0';
   signal But1 : std_logic := '0';
   signal But2 : std_logic := '0';
   signal But3 : std_logic := '0';
   signal But4 : std_logic := '0';

 	--Outputs
   signal C1 : std_logic_vector(3 downto 0);
   signal C2 : std_logic_vector(3 downto 0);
   signal C4 : std_logic_vector(3 downto 0);
   signal C5 : std_logic_vector(3 downto 0);
   signal C7 : std_logic_vector(3 downto 0);
   signal C8 : std_logic_vector(3 downto 0);
   signal Vsel : std_logic_vector(2 downto 0);
   signal Vselseg : std_logic_vector(1 downto 0);
   signal Wac : std_logic;
   signal Alac : std_logic;
   signal feS : std_logic_vector(3 downto 0);
   signal ftS : std_logic_vector(3 downto 0);
   signal feM : std_logic_vector(3 downto 0);
   signal ftM : std_logic_vector(3 downto 0);
   signal feH : std_logic_vector(3 downto 0);
   signal ftH : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk25MHz_period : time := 40 ns;
   constant clk100Hz_period : time :=  10000 ns;
   constant clk1Hz_period : time := 1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: toplevel PORT MAP (
          clk25MHz => clk25MHz,
          clk100Hz => clk100Hz,
          clk1Hz => clk1Hz,
          But1 => But1,
          But2 => But2,
          But3 => But3,
          But4 => But4,
          C1 => C1,
          C2 => C2,
          C4 => C4,
          C5 => C5,
          C7 => C7,
          C8 => C8,
          Vsel => Vsel,
          Vselseg => Vselseg,
          Wac => Wac,
          Alac => Alac,
          feS => feS,
          ftS => ftS,
          feM => feM,
          ftM => ftM,
          feH => feH,
          ftH => ftH
        );

   -- Clock process definitions
   clk25MHz_process :process
   begin
		clk25MHz <= '0';
		wait for clk25MHz_period/2;
		clk25MHz <= '1';
		wait for clk25MHz_period/2;
   end process;
 
   clk100Hz_process :process
   begin
		clk100Hz <= '0';
		wait for wait for clk100Hz_period-clk25MHz_period;
		clk100Hz <= '1';
		wait for clk100Hz_period/2;
   end process;
 
   clk1Hz_process :process
   begin
		clk1Hz <= '0';
		wait for clk1Hz_period-clk25MHz_period;
		clk1Hz <= '1';
		wait for clk1Hz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      But1 <= '0';
		But2 <= '0';
		But3 <= '0';
		But4 <= '0';
		wait for 110 ns; 
		But1 <= '1';
		wait for 40 ns --1
		But1 <= '0';
		wait for 500 ns;
		But1 <= '1';
		wait for 40 ns --2
		But1 <= '0';
		wait for 500 ns;
		But1 <= '1';
		wait for 40 ns --3
		But1 <= '0';
		wait for 500 ns;
		But1 <= '1';
		wait for 40 ns --4
		But1 <= '0';
		wait for 500 ns;
		But1 <= '1';
		wait for 40 ns --0
		But1 <= '0';
      wait;
   end process;

END;
