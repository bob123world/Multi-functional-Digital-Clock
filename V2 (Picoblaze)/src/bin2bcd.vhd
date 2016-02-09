----------------------------------------------------------------------------------
-- Company: EchelonEmbedded.com
-- Engineer: Doug Wenstrand
-- 
-- Create Date:    21:14:31 02/26/2008 
-- Design Name: 
-- Module Name:    toplevel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This is a starting point design for using the picoblaze
-- soft core processor on the digilent NEXYS2 Spartan3E starter kit.
-- Interfaces to the seven segment display, switches, buttons, leds, and serial
-- ports are provided as a quick start for any end application.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bin2bcd is
    Port (  bin : in  STD_LOGIC_VECTOR(7 downto 0);
				e : out STD_LOGIC_VECTOR(3 downto 0);
				t : out STD_LOGIC_VECTOR(3 downto 0)			
				);
end bin2bcd;

architecture Behavioral of bin2bcd is


function to_bcd ( bin : std_logic_vector(7 downto 0) ) return std_logic_vector is
	variable i : integer:=0;
	variable bcd : std_logic_vector(7 downto 0) := (others => '0');
	variable bint : std_logic_vector(7 downto 0) := bin;

	begin
		for i in 0 to 7 loop -- repeating 8 times.
			bcd(7 downto 1) := bcd(6 downto 0); --shifting the bits.
			bcd(0) := bint(7);
			bint(7 downto 1) := bint(6 downto 0);
			bint(0) :='0';

			if(i < 7 and bcd(3 downto 0) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;

			if(i < 7 and bcd(7 downto 4) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;

		end loop;
	return bcd;
end to_bcd;


begin

t <= to_bcd(bin)(7 downto 4);
e <= to_bcd(bin)(3 downto 0);


end Behavioral;