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

entity interrupthandler is
	Port (  clk : in STD_LOGIC;
			clk100Hz: in STD_LOGIC;
			interrupt_ack: in STD_LOGIC;
			interrupt: out STD_LOGIC			
				);
end interrupthandler;

architecture Behavioral of interrupthandler is

signal interrupt_int : std_logic := '0';

begin

process(clk)
begin

if rising_edge(clk) then
	if clk100Hz = '1' and interrupt_int = '0' then --100Hz Puls en nog geen interrupt
		interrupt_int <= '1'; --interrupt uitzenden
	end if;
	
	if interrupt_ack = '1' then 
		interrupt_int <= '0';
	end if;	
end if;


end process;

interrupt <= interrupt_int;

end Behavioral;