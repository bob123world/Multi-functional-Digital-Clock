--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:49:17 11/14/2012
-- Design Name:   
-- Module Name:   C:/Users/Michael/Documents/Elektronica-ICT/Lab Programeerbare Digitale Systemen 3/Project/Xilinx/Gino/tb_ButDriv.vhd
-- Project Name:  Gino
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Button_Driver
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
 
ENTITY tb_ButDriv IS
END tb_ButDriv;
 
ARCHITECTURE behavior OF tb_ButDriv IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Button_Driver
    PORT(
         clk : IN  std_logic;
         B1 : IN  std_logic;
         B2 : IN  std_logic;
         B3 : IN  std_logic;
         B4 : IN  std_logic;
         StartCycl : IN  std_logic;
         EndCycl : IN  std_logic;
         Buttons : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal B1 : std_logic := '0';
   signal B2 : std_logic := '0';
   signal B3 : std_logic := '0';
   signal B4 : std_logic := '0';
   signal StartCycl : std_logic := '0';
   signal EndCycl : std_logic := '0';

 	--Outputs
   signal Buttons : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Button_Driver PORT MAP (
          clk => clk,
          B1 => B1,
          B2 => B2,
          B3 => B3,
          B4 => B4,
          StartCycl => StartCycl,
          EndCycl => EndCycl,
          Buttons => Buttons
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
      B1 <= '0';
		B2 <= '0';
		B3 <= '0';
		B4 <= '0';
		StartCycl <= '0';
		EndCycl <= '0';
		wait for 110 ns;
		B1 <= '1';
		wait for 40 ns;
		B1 <= '0';
		wait for 200 ns;
		StartCycl <= '1';
		wait for 40 ns;
		StartCycl <= '0';
		wait for 500 ns;
		EndCycl <= '1';
		wait for 40 ns;
		EndCycl <= '0';
		wait for 100 ns;
		StartCycl <= '1';
		wait for 40 ns;
		StartCycl <= '0';
		wait for 100 ns;
		B2 <= '1';
		wait for 40 ns;
		B2 <= '0';
		wait for 400 ns;
		EndCycl <= '1';
		wait for 40 ns;
		EndCycl <= '0';
		wait for 100 ns;
		StartCycl <= '1';
		wait for 40 ns;
		StartCycl <= '0';
		wait for 500 ns;
		EndCycl <= '1';
		wait for 40 ns;
		EndCycl <= '0';
		wait;
   end process;

END;
