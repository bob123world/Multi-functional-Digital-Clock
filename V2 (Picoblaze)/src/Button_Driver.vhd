----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:37:52 11/04/2012 
-- Design Name: 
-- Module Name:    Button_Driver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Button_Driver is
    Port ( clk : in  STD_LOGIC;
           B1 : in  STD_LOGIC;
           B2 : in  STD_LOGIC;
           B3 : in  STD_LOGIC;
           B4 : in  STD_LOGIC;
			  StartCycl : in STD_LOGIC;
			  EndCycl : in STD_LOGIC;
           Buttons : out  STD_LOGIC_VECTOR (7 downto 0));
end Button_Driver;

architecture Behavioral of Button_Driver is

signal but_int, buttons_int : std_logic_vector (7 downto 0) := "00000000";
begin

process(clk)
	
	begin
		if rising_edge(clk) then
			if (B1 = '1') then
				but_int <= "00000001";
			elsif (B2 = '1') then
				but_int <= "00000010";
			elsif (B3 = '1') then
				but_int <= "00000011";
			elsif (B4 = '1') then
				but_int <= "00000100";
			end if;
			if (StartCycl = '1') then
				buttons_int <= but_int;
			end if;
			if (EndCycl = '1') and (buttons_int /= "00000000") then
				buttons_int <= "00000000";
			   but_int <= "00000000";
			end if;
		end if;
		
end process;

Buttons <= buttons_int;
end Behavioral;